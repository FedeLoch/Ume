Class {
	#name : 'UmeAPITest',
	#superclass : 'TestCase',
	#category : 'Ume-API Tests',
	#package : 'Ume',
	#tag : 'API Tests'
}

{ #category : 'tests' }
UmeAPITest >> assertSuccess: result [

	self assert: (result tests groupedBy: [ :r | r result class ]) size equals: 1.
	self assert: (result tests groupedBy: [ :r | r result class ]) keys first equals: UmeEvalSuccess.
]

{ #category : 'tests' }
UmeAPITest >> testIntegerAddition [

	| receiver argumentConstraints property schema runner |
	
	receiver := UmeObjectConstraint new 
    	generator: (UmeGenerator oneOf: (SmallInteger minVal to: SmallInteger maxVal)).

	argumentConstraints := { 
    	UmeObjectConstraint new generator: (UmeGenerator oneOf: (SmallInteger minVal to: SmallInteger maxVal)) 
	}.

	property := [ :a :args :result | result = (a + args first) ].

	schema := UmeSchema new
    	receiverConstraint: receiver;
    	argumentConstraints: argumentConstraints;
    	property: property.

	runner := ((UmeRunner test: SmallInteger >> #+ from: schema times: 5) guidedByExecutionTime)run.
	
	self assertSuccess: runner.
	self assert: (runner tests size) equals: 5. 
]

{ #category : 'tests' }
UmeAPITest >> testNeoJsonPerformance [

	| mutator generator receiverConstraint argumentConstraints schema runner |
	
	
	"Define the grammar-based mutator."
	mutator := UmeGrammarLiteralsMutator  from: JSONGrammar new.
	mutator maxInputSize: 30.

	"Corpus-based generator starts with a seed and evolves it."
	generator := UmeCorpusGenerator new
		  seeds: { '{"n":true,"x":6}' };
		  mutationsPerIteration: 1;
		  mutators: { mutator };
		  heuristic: UmePickBestElementDifferenceHeuristic new.

	receiverConstraint := UmeObjectConstraint new
		generator: (UmeConstantGenerator new value: NeoJSONReader).
	
	argumentConstraints := {
		UmeObjectConstraint new generator: generator
	}.

	schema := UmeSchema new
		receiverConstraint: receiverConstraint;
		argumentConstraints: argumentConstraints;
		score: [ :re :inputs :res | 1 ];
		property: [ :regex :input :result | true ].

	runner := ((UmeRunner test: NeoJSONReader class >> #fromString: from: schema for: 20 seconds) "guidedByMethodsCalls") run.
	

	self assertSuccess: runner.
	

]

{ #category : 'tests' }
UmeAPITest >> testSortingCollection [

	| receiver collGen property schema runner |
	
	collGen := UmeGenerator onceInstance: [ :instance :props |
		(Random new nextIntegerBetween: 1 and: 10) timesRepeat: [
			instance add: (props at: 'item') gen
		] . instance ] of: OrderedCollection.

	receiver := UmeObjectConstraint new
    	objectClass: OrderedCollection;
    	generator: collGen;
    	props: { 
        	'item' -> (UmeObjectConstraint new generator: (UmeGenerator oneOf: (1 to: 10))) 
    	}.

	"Property: Result is sorted, and size remains the same"
	property := [ :coll :args :res | 
    	res isSorted & (res size = coll size) 
	].

	schema := UmeSchema new 
    	receiverConstraint: receiver; 
    	property: property.

	runner := UmeRunner test: SequenceableCollection >> #sort from: schema for: 3 seconds.

	runner guidedByExecutionTime.

	runner run
]
