Class {
	#name : 'UmeNeoJsonTest',
	#superclass : 'UmeAPITest',
	#instVars : [
		'schema',
		'receiver',
		'argument'
	],
	#category : 'Ume-API Tests',
	#package : 'Ume',
	#tag : 'API Tests'
}

{ #category : 'running' }
UmeNeoJsonTest >> setUp [

	| mutator generator|
	super setUp.
	
	mutator := UmeGrammarLiteralsMutator  from: JSONGrammar new.
	mutator maxInputSize: 30.

	"Corpus-based generator starts with a seed and evolves it."
	generator := UmeCorpusGenerator new
		  seeds: { '{"n":true,"x":6}' };
		  mutationsPerIteration: 1;
		  mutators: { mutator };
		  heuristic: UmePickBestElementDifferenceHeuristic new.

	receiver := UmeObjectConstraint new
		generator: (UmeConstantGenerator new value: NeoJSONReader).
	
	argument := {
		UmeObjectConstraint new generator: generator
	}.

	schema := UmeSchema new
		receiverConstraint: receiver;
		argumentConstraints: argument ;
		score: [ :re :inputs :res | 1 ];
		property: [ :regex :input :result | true ].


]

{ #category : 'tests' }
UmeNeoJsonTest >> testNeoJsonPerformance [

	|runner|
	runner := ((UmeRunner test: NeoJSONReader class >> #fromString: from: schema for: 20 seconds) "guidedByMethodsCalls") run.
	self assertSuccess:runner.
	self assert:(runner totalTime >= 20 seconds).
	

	^ {
		self corpusGenFrom: '[]' mpi: 3 mutators: {
			(UmeGrammarDerivationMutator from: JSONGrammar new) maxInputSize: 100
		}
	}
]

{ #category : 'running' }
UmeNeoJSONTest >> assert: receiver arguments: arguments result: result [

	^ (NeoJSONWriter toString: result) = arguments first 
]

{ #category : 'running' }
UmeNeoJSONTest >> generateTests [

	<script: 'self new generateTests'>
	super generateTests: 1 hour
]

{ #category : 'running' }
UmeNeoJSONTest >> guidedBy [

	"self guidedByMethodsCalls"
	self guidedByBytecodes 
]

{ #category : 'running' }
UmeNeoJSONTest >> receiverGenerator [

	^ self constantGen: NeoJSONReader
]

{ #category : 'running' }
UmeNeoJSONTest >> targetMethod [

	^ NeoJSONReader class >> #fromString:
]

{ #category : 'Ume dynamic tests' }
UmeNeoJSONTest >> test_474231552 [

	self doTest: {
			'method' -> (NeoJSONReader class>>#fromString:) selector.
			'receiver' -> 'Class[#NeoJSONReader]'.
			'arguments' -> '[''[[[[[[[[[[],"","r"],{"":null}],8,4],5,0],3,6],2,2],0,9],3,0],9,8]'']'.
		} asDictionary
]

{ #category : 'Ume dynamic tests' }
UmeNeoJSONTest >> test_594914560 [

	self doTest: {
			'method' -> (NeoJSONReader class>>#fromString:) selector.
			'receiver' -> 'Class[#NeoJSONReader]'.
			'arguments' -> '[''[[[[[[[[[[[[[[[[[4,7],5,5],5,7],4,8],8,7],7,4],6,2],0,8],4,1],5,6],8,4],9,0],3,6],2,2],0,9],3,0],9,8]'']'.
		} asDictionary
]

{ #category : 'Ume dynamic tests' }
UmeNeoJSONTest >> test_774203648 [

	self doTest: {
			'method' -> (NeoJSONReader class>>#fromString:) selector.
			'receiver' -> 'Class[#NeoJSONReader]'.
			'arguments' -> '[''[]'']'.
		} asDictionary
]
