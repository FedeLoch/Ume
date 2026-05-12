Class {
	#name : 'UmeAPIIntegerTest',
	#superclass : 'UmeAPITest',
	#instVars : [
		'schema',
		'receiver',
		'property',
		'arguments'
	],
	#category : 'Ume Tests-API Tests',
	#package : 'Ume Tests',
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
    	property: property;
		method: SmallInteger >> #+.
]

{ #category : 'tests' }
UmeAPIIntegerTest >> successful: aResult [ 
	|groups|
	groups := aResult tests groupedBy: [ :r | r result class ].
	
	^ ( groups size = 1) and: [ groups keys first = UmeEvalSuccess ]
]

{ #category : 'tests' }
UmeAPIIntegerTest >> testIntegerAdditionByCount [ 

	| runner result | 
	runner := UmeRunner testWithLowCost: schema times: 5.
	
	runner guidedByExecutionTime.
	runner collectAllCases.
	result := runner run.
	
	self assertSuccess: result.
	self assert: (result tests size) equals: 5. 
]

{ #category : 'tests' }
UmeAPIIntegerTest >> testIntegerAdditionByTime [

	| runner result |

	runner := UmeRunner testWithLowCost: schema for: 2 seconds.
	
	runner guidedByExecutionTime.
	result := runner run.
	
	self assertSuccess: result.
	self assert: (result totalTime >= 2 seconds).
]

{ #category : 'tests' }
UmeAPIIntegerTest >> testIntegerAdditionOnlyOutliers [

	| runner result | 
	runner := UmeRunner testWithLowCost: schema times: 5.
	
	runner guidedByExecutionTime.
	result := runner run.
	
	(result tests) do: [ :t | self assert: t feedback improvement > 0 ].
	self assert: (result totalTest) equals: 5. 
]
