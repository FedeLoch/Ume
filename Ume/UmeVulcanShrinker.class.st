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

	| nodeSet properSubsets |
				
	nodeSet := nodeSequence copyFrom: windowPosition to: (windowPosition + windowSize - 1).
	properSubsets := self generateProperSubsetsOf: nodeSet.
	properSubsets do: [ :nodesToRemove |
		| backup  |
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
	(self triggerBug: tree upperBound: bound ) ifTrue: [ 
		nodeSequence removeAll: nodesToRemove.  
	].
	self failedMinimization.
	backup associationsDo: [ :parentAndchildren |
		| parent |
		parent := parentAndchildren key.
		parent children: ( parentAndchildren value).
	]	
]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> generateProperSubsetsOf: nodeSet [

	^ nodeSet combinations: windowSize
]

{ #category : 'accessing' }
UmeVulcanShrinker >> grammar: aGrammar [

	grammar := aGrammar.
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

	| minimum index prevByMain attempts |
	
	minimum := self copyTree: originalTree.
	prevByMain := nil.
	index := 1.
	attempts := 0.
	
	[ true ] whileTrue: [
		prevByMain := self copyTree: minimum.
		minimum := self reduce: minimum bound: bound.
		( minimum treeSize < prevByMain treeSize ) ifTrue: [
			attempts := 0.
			prevByMain := minimum 
	 	].
		[ (minimum treeSize = prevByMain treeSize ) and: [ index <= 3] ] whileTrue: [ 
			minimum := self reduce: minimum at: index with: bound.
			attempts := attempts + 1.
			( minimum treeSize = prevByMain treeSize ) ifTrue: [ 
				index := index + 1.
				attempts := 0.
			]
		].
	
		( minimum treeSize < prevByMain treeSize) ifTrue: [ 
			attempts := 0
		] ifFalse: [ (attempts > limit ) ifTrue: [ 
			index := index + 1. 
			attempts:= 0 
			]
		].
	
		(index >= 3 ) ifTrue: [ ^ minimum ].
	].
]

{ #category : 'accessing' }
UmeVulcanShrinker >> oracle: aOracle [

	oracle := aOracle.
	mainReducer oracle: aOracle.
	subtreeShrinker oracle: aOracle.
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduce: aTree at: index with: bound [

	( index = 1 ) ifTrue: [ ^ self subtreeReplacement: aTree bound: bound ].
	( index = 2 ) ifTrue: [ ^ self identifierReplacement: aTree bound: bound ].
	( index = 3 ) ifTrue: [ ^ self treeBasedLEE: aTree bound: bound ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduce: aTree bound: bound [

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

	| t level nodeSequence maxReduction |
	
	t := aTree.
	level := 0.
	nodeSequence := { aTree root}. 
	maxReduction := false. 
	
	[ nodeSequence size < windowSize and: [ nodeSequence isNotEmpty ] ] whileTrue: [
		level := level + 1. 
		nodeSequence := t allNodesAtLevel: level.
	].

	nodeSequence size < windowSize ifTrue: [ ^ t ].

	[maxReduction] whileFalse: [ | windowPosition |
		windowPosition := 1.
		[ windowPosition + windowSize < nodeSequence size ] whileTrue: [ 
			self cutTree: nodeSequence position: windowPosition bound: bound tree: t 
		].
		(nodeSequence allSatisfy: [ :node | node isLeaf ] ) ifTrue: [ maxReduction := true ].
		level := level +1.
		nodeSequence := t allNodesAtLevel: level
	].

	^ t
]
