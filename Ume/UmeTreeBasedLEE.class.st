Class {
	#name : 'UmeTreeBasedLEE',
	#superclass : 'UmeVulcanAuxiliaryReducer',
	#instVars : [
		'windowSize'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeTreeBasedLEE >> cutTree: nodeSequence position: windowPosition bound: bound tree: tree [
	
	| nodeSet properSubsets newNodeSequence |
				
	newNodeSequence := nodeSequence asOrderedCollection.
	nodeSet := newNodeSequence copyFrom: windowPosition to: (windowPosition + windowSize - 1).
	properSubsets := self generateProperSubsetsOf: nodeSet.
	
	properSubsets do: [ :nodesToRemove | | backup  |
		backup := Dictionary new. 
		nodesToRemove do: [ :node |
			node parent ifNotNil: [ :parent |
				backup at: parent ifAbsentPut: [ parent children copy ].
			] 
		].

		nodesToRemove do: [ :node |
			node parent ifNotNil: [ :parent | parent removeChild: node ]. 
		].

		self minimizationDone.
		(self triggerBug: tree upperBound: bound) ifTrue: [ 
			newNodeSequence removeAll: nodesToRemove. 
			^ newNodeSequence. 
		] ifFalse: [ 
			self failedMinimization.
			backup associationsDo: [ :parentAndchildren | | parent |
				parent := parentAndchildren key.
				parent children: (parentAndchildren value).
			]
		]
	].
	
	^ newNodeSequence
]

{ #category : 'as yet unclassified' }
UmeTreeBasedLEE >> findFirstNodeLevel: currentTree [

	| nodeSequence currentTreeLevel |
	
	currentTreeLevel := 0.
	nodeSequence := {currentTree root}.
	[nodeSequence size < windowSize and: [ nodeSequence isNotEmpty ] ]whileTrue: [
		currentTreeLevel := currentTreeLevel + 1. 
		nodeSequence := currentTree allNodesAtLevel: currentTreeLevel.
	].

	( nodeSequence size < windowSize ) ifTrue: [ currentTreeLevel := nil ]. 

	^ currentTreeLevel. 
]

{ #category : 'as yet unclassified' }
UmeTreeBasedLEE >> generateProperSubsetsOf: nodeSet [

	^ ((nodeSet size to: 1 by: -1 ) inject: OrderedCollection new into: [ :subsets :i |
			subsets addAll: (nodeSet combinations: i). subsets ]) reversed
]

{ #category : 'as yet unclassified' }
UmeTreeBasedLEE >> initialize [ 

	super initialize.
	windowSize := 4. "default value given by the paper"
]

{ #category : 'as yet unclassified' }
UmeTreeBasedLEE >> reduce: aTree bound: bound [

	| currentTree currentTreeLevel nodeSequence |
	
	currentTree := aTree.
	currentTreeLevel := 0.
	
	currentTreeLevel := self findFirstNodeLevel: currentTree.
	currentTreeLevel ifNil: [ ^ currentTree ].	
	nodeSequence := currentTree allNodesAtLevel: currentTreeLevel.


	[ nodeSequence anySatisfy: #isLeaf ] whileTrue: [ | windowPosition |
		windowPosition := 1.
		
		[ (windowPosition + windowSize - 1) <= nodeSequence size ] whileTrue: [ | initialSeqSize |
			initialSeqSize := nodeSequence size.
			nodeSequence:= self cutTree: nodeSequence position: windowPosition bound: bound tree: currentTree.
			(initialSeqSize = nodeSequence size) ifTrue: [ windowPosition := windowPosition + 1 ]
		].
	
		currentTreeLevel := currentTreeLevel +1.
		nodeSequence := currentTree allNodesAtLevel: currentTreeLevel
	].

	^ currentTree
]

{ #category : 'as yet unclassified' }
UmeTreeBasedLEE >> windowSize: aSize [

	windowSize := aSize 
]
