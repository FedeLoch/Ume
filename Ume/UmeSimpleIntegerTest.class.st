Class {
	#name : 'UmeSimpleIntegerTest',
	#superclass : 'UmeAPITest',
	#instVars : [
		'schema',
		'receiver',
		'property',
		'arguments'
	],
	#category : 'Ume-API Tests',
	#package : 'Ume',
	#tag : 'API Tests'
}

{ #category : 'running' }
UmeSimpleIntegerTest >> setUp [ 

	super setUp.
	
	receiver := UmeObjectConstraint new 
    	generator: (UmeGenerator oneOf: (SmallInteger minVal to: SmallInteger maxVal)).

	arguments := { 
    	UmeObjectConstraint new generator: (UmeGenerator oneOf: (SmallInteger minVal to: SmallInteger maxVal)) 
	}.

	property := [ :a :args :result | result = (a + args first) ].

	schema := UmeSchema new
    	receiverConstraint: receiver;
    	argumentConstraints: arguments;
    	property: property.
]

{ #category : 'tests' }
UmeSimpleIntegerTest >> successful: aResult [ 
	|groups|
	groups := aResult tests groupedBy: [ :r | r result class ].
	
	^ ( groups size = 1) and: [ groups keys first = UmeEvalSuccess ].
	
]

{ #category : 'tests' }
UmeSimpleIntegerTest >> testIntegerAdditionByCount [ 

	| runner result| 
	runner := UmeRunner test: SmallInteger >> #+ from: schema times: 5.
	runner guidedByExecutionTime.
	result := runner run.
	
	self assertSuccess: result.
	self assert: (result tests size) equals: 5. 
]

{ #category : 'tests' }
UmeSimpleIntegerTest >> testIntegerAdditionByTime [

	| runner result | 
	runner := UmeRunner test: SmallInteger >> #+ from: schema for: 5 seconds.
	runner guidedByExecutionTime.
	result := runner run.
	
	self assertSuccess: result.
	self assert: (result totalTime >= 5 seconds).
]
