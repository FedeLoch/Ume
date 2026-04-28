Class {
	#name : 'UmeAPITest',
	#superclass : 'TestCase',
	#category : 'Ume-API Tests',
	#package : 'Ume',
	#tag : 'API Tests'
}

{ #category : 'tests' }
UmeAPITest >> assertSuccess: result [

	"TODO: think about what make a campaign fonctionnal"
	self assert: (result tests groupedBy: [ :r | r result class ]) size equals: 1.
	self assert: (result tests groupedBy: [ :r | r result class ]) keys first equals: UmeEvalSuccess.
]

{ #category : 'running' }
UmeAPITest >> setUp [
	
	super setUp.
	self timeLimit: 1 minute. 
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
