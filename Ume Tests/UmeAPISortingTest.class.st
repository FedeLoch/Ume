Class {
	#name : 'UmeAPISortingTest',
	#superclass : 'UmeAPITest',
	#instVars : [
		'schema',
		'receiver',
		'property'
	],
	#category : 'Ume Tests-API Tests',
	#package : 'Ume Tests',
	#tag : 'API Tests'
}

{ #category : 'running' }
UmeAPISortingTest >> setUp [ 

	|collGen|
	
	super setUp.
	self timeLimit: 2 minutes.
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

	property := [ :coll :args :res | 
    	res isSorted & (res size = coll size) 
	].

	schema := UmeSchema new 
    	receiverConstraint: receiver; 
    	property: property;
		method: SequenceableCollection >> #sort.

]

{ #category : 'running' }
UmeAPISortingTest >> successful: aResult [ 
	|groups|
	groups := aResult tests groupedBy: [ :r | r result class ].
	
	^ (groups size = 1) and: [ groups keys first = UmeEvalSuccess ]
]

{ #category : 'tests' }
UmeAPISortingTest >> testSortingCollectionByCount [

	| runner result |
	
	runner := UmeRunner testWithLowCost: schema times: 5.
	
	runner guidedByExecutionTime.
	runner collectAllCases.
	result := runner run.

	self assertSuccess: result.
	self assert: (result tests size) equals: 5. 
]

{ #category : 'tests' }
UmeAPISortingTest >> testSortingCollectionByTimes [

	| runner result |

	runner := UmeRunner testWithLowCost: schema for: 10 seconds.
	
	runner guidedByExecutionTime.
	result := runner run.

	self assertSuccess: result.
	self assert: (result totalTime >= 5 seconds).
]

{ #category : 'tests' }
UmeAPISortingTest >> testSortingCollectionOutliersOnly [

	| runner result |
	
	runner := UmeRunner testWithLowCost: schema times: 5.
	
	runner guidedByExecutionTime.
	result := runner run.

	"self assertSuccess: result."
	(result tests) do: [ :t | self assert: t feedback improvement > 0 ].
]
