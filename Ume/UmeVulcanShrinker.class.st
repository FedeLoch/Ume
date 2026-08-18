Class {
	#name : 'UmeVulcanShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'mainReducer',
		'auxiliaryReducers',
		'windowSize',
		'limit',
		'subtreeShrinker',
		'identidierShrinker'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeVulcanShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeVulcanShrinker >> cutTree: nodeSequence position: windowPosition bound: bound tree: tree [

	| nodeSet properSubsets newNodeSequence |
				
	newNodeSequence := nodeSequence copy.
	nodeSet := newNodeSequence copyFrom: windowPosition to: (windowPosition + windowSize - 1).
	properSubsets := self generateProperSubsetsOf: nodeSet.
	properSubsets do: [ :nodesToRemove | | backup  |
		backup := Dictionary new. 
		nodesToRemove do: [ :node |
			node parent ifNotNil: [ :p |
				backup at: p ifAbsentPut: [ p children copy ].
			] 
		].

	nodesToRemove do: [ :node |
		node parent ifNotNil: [ :p | p removeChild: node ]. 
	].

	self minimizationDone.
	(self triggerBug: tree upperBound: bound) ifTrue: [ 
		newNodeSequence removeAll: nodesToRemove. 
	] ifFalse: [ 
		self failedMinimization.
		backup associationsDo: [ :parentAndchildren | | parent |
			parent := parentAndchildren key.
			parent children: (parentAndchildren value).
		]
	].
	
	^ newNodeSequence
]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> findFirstNodeLevel: currentTree [

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

{ #category : 'accessing' }
UmeVulcanShrinker >> generateProperSubsetsOf: nodeSet [

	^ nodeSet combinations: windowSize
]

{ #category : 'accessing' }
UmeVulcanShrinker >> grammar: aGrammar [

	super grammar: aGrammar. 
	mainReducer grammar: aGrammar.
	subtreeShrinker grammar: aGrammar.
]

{ #category : 'accessing' }
UmeVulcanShrinker >> identifierReplacement: aTree bound: bound [

	| allLeaf |
	allLeaf := OrderedCollection new.
	aTree allNodes do: [ :node | (node isLeaf) ifTrue: [ allLeaf add: node ] ].
	
	allLeaf do: [ :leaf |
		allLeaf do: [ :leafToReplace | 
			(leafToReplace parent tag == leaf parent tag) ifTrue: [ | previousToken |
				previousToken := leafToReplace token.
				leafToReplace token: leaf token.
				( self triggerBug: aTree upperBound: bound ) ifFalse: [
					leafToReplace token: previousToken.
				]
			]
		]
	].
				
				
	^ aTree 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> initialize [

	super initialize.
	
	maxIterations := 1. 
	windowSize := 4.
	limit := 100.  
	
	mainReducer := UmeHDDShrinker new. 
	subtreeShrinker := UmeGRABRShrinker new.
	subtreeShrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
]

{ #category : 'accessing' }
UmeVulcanShrinker >> limit: aNumber [

	limit := aNumber 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> mainReducer: aReducer [

	mainReducer := aReducer.
	mainReducer grammar: grammar. 
]

{ #category : 'shrinking' }
UmeVulcanShrinker >> minimizeOne: originalTree upperBound: bound [

	| minimumInput index prevInputByMain attempts |
	
	minimumInput := self copyTree: originalTree.
	index := 1.
	attempts := 0.
	
	[ true ] whileTrue: [
	
		"Main reducer"
		prevInputByMain := self copyTree: minimumInput.	
		minimumInput := self reduceMain: minimumInput bound: bound.
		( minimumInput treeSize < prevInputByMain treeSize ) ifTrue: [
			attempts := 0.
			prevInputByMain := minimumInput 
	 	].
	
		"Auxiliary reducer"	
		[ (minimumInput treeSize = prevInputByMain treeSize ) and: [ index <= 3] ] whileTrue: [ 
			minimumInput := self reduceAuxiliar: minimumInput at: index bound: bound.
			attempts := attempts + 1.
			( minimumInput treeSize = prevInputByMain treeSize ) ifTrue: [ 
				index := index + 1.
				attempts := 0.
			]
		].
	
		( minimumInput treeSize < prevInputByMain treeSize) ifTrue: [ 
			attempts := 0
		] ifFalse: [ (attempts > limit ) ifTrue: [ 
			index := index + 1. 
			attempts:= 0 
			]
		].
	
		(index >= 3 ) ifTrue: [ ^ minimumInput ].
	].
]

{ #category : 'accessing' }
UmeVulcanShrinker >> oracle: aOracle [

	super oracle: aOracle. 
	mainReducer oracle: aOracle.
	subtreeShrinker oracle: aOracle.
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduceAuxiliar: aTree at: index bound: bound [

	( index = 1 ) ifTrue: [ ^ self subtreeReplacement: aTree bound: bound ].
	( index = 2 ) ifTrue: [ ^ self identifierReplacement: aTree bound: bound ].
	( index = 3 ) ifTrue: [ ^ self treeBasedLEE: aTree bound: bound ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduceMain: aTree bound: bound [

	^ mainReducer minimizeOne: aTree upperBound: bound 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> setWindowSize: aSize [

	windowSize := aSize
]

{ #category : 'accessing' }
UmeVulcanShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
	
]

{ #category : 'accessing' }
UmeVulcanShrinker >> subtreeReplacement: aTree bound: bound [

	self minimizationDone.
	
	^ subtreeShrinker minimizeOne: aTree upperBound: bound.
]

{ #category : 'accessing' }
UmeVulcanShrinker >> treeBasedLEE: aTree bound: bound [

	| currentTree currentTreeLevel nodeSequence |
	
	currentTree := aTree.
	currentTreeLevel := 0.
	
	currentTreeLevel := self findFirstNodeLevel: currentTree.
	nodeSequence := currentTree allNodesAtLevel: currentTreeLevel.
	currentTreeLevel ifNil: [ ^ currentTree ].

	[ true ] whileTrue: [ | windowPosition |
		windowPosition := 1.
		[ windowPosition + windowSize < nodeSequence size ] whileTrue: [ | initialSeqSize |
			initialSeqSize := nodeSequence size.
			nodeSequence:= self cutTree: nodeSequence position: windowPosition bound: bound tree: currentTree.
			(initialSeqSize == nodeSequence size) ifTrue: [ windowPosition := windowPosition + 1 ]
		].
		(nodeSequence allSatisfy: [ :node | node isLeaf ] ) ifTrue: [ ^ currentTree ].
		currentTreeLevel := currentTreeLevel +1.
		nodeSequence := currentTree allNodesAtLevel: currentTreeLevel
	].

	^ currentTree
]
