Class {
	#name : 'UmeSortingCollectionTest',
	#superclass : 'UmeAPITest',
	#instVars : [
		'schema',
		'receiver',
		'property'
	],
	#category : 'Ume-API Tests',
	#package : 'Ume',
	#tag : 'API Tests'
}

{ #category : 'running' }
UmeSortingCollectionTest >> setUp [ 

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
    	property: property.

]

{ #category : 'running' }
UmeSortingCollectionTest >> successful: aResult [ 
	|groups|
	groups := aResult tests groupedBy: [ :r | r result class ].
	
	^ (groups size = 1) and: [ groups keys first = UmeEvalSuccess ]
]

{ #category : 'tests' }
UmeSortingCollectionTest >> testSortingCollectionByCount [

	| runner |
	runner := ((UmeRunner test: SequenceableCollection >> #sort from: schema times: 5) guidedByExecutionTime) run.

	self assertSuccess: runner.
	self assert: (runner tests size) equals: 5. 
]

{ #category : 'tests' }
UmeSortingCollectionTest >> testSortingCollectionByTimes [

	| runner |
	runner := ((UmeRunner test: SequenceableCollection >> #sort from: schema for: 10 seconds) guidedByExecutionTime) run.

	self assertSuccess: runner.
	self assert: (runner totalTime >= 10 seconds).
]
