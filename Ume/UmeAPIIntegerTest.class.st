Class {
	#name : 'UmeAPIIntegerTest',
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
UmeAPIIntegerTest >> setUp [ 

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
UmeAPIIntegerTest >> successful: aResult [ 
	|groups|
	groups := aResult tests groupedBy: [ :r | r result class ].
	
	^ ( groups size = 1) and: [ groups keys first = UmeEvalSuccess ]
]

{ #category : 'tests' }
UmeAPIIntegerTest >> testIntegerAdditionByCount [ 

	| runner | 
	runner := ((UmeRunner test: SmallInteger >> #+ from: schema times: 5) guidedByExecutionTime)run.
	
	self assertSuccess: runner.
	self assert: (runner tests size) equals: 5. 
]

{ #category : 'tests' }
UmeAPIIntegerTest >> testIntegerAdditionByTime [

	| runner | 
	runner := ((UmeRunner test: SmallInteger >> #+ from: schema for: 5 seconds) guidedByExecutionTime)run.
	
	self assertSuccess: runner.
	self assert: (runner totalTime >= 5 seconds).
]
