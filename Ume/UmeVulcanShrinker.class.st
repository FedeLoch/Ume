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

{ #category : 'accessing' }
UmeVulcanShrinker >> generateProperSubsetsOf: nodeSet [

	| subsets |
	
	subsets := OrderedCollection new. 
	nodeSet do: [  :node |
		| newSubset |
		newSubset := subsets collect: [  :each | each copyWith: node ].
		subsets addAll: newSubset.
	].
]

{ #category : 'accessing' }
UmeVulcanShrinker >> grammar: aGrammar [

	grammar := aGrammar.
	mainReducer grammar: aGrammar.
	subtreeShrinker grammar: aGrammar.
	identidierShrinker grammar: aGrammar
]

{ #category : 'accessing' }
UmeVulcanShrinker >> identifierRemplacement: aTree bound: bound [

	^ identidierShrinker minimizeOne: aTree upperBound: bound 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> initialize [

	super initialize.
	mainReducer := UmeHDDShrinker new. 
	windowSize := 4.
	limit := 5.  
	
	subtreeShrinker := UmeGRABRShrinker new.
	subtreeShrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
	
	identidierShrinker := UmeGRABRShrinker new.
	identidierShrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction .
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

	| minTree index attemps prevByMain |
	
	minTree := originalTree.
	index := 1.
	attemps := 0.
	prevByMain := minTree.
	minTree := self reduce: minTree bound: bound.
	( minTree treeSize < prevByMain treeSize ) ifTrue: [
		attemps := 0.
		prevByMain := minTree 
	 ].
	
	[ (minTree = prevByMain) and: [ index <= 3] ] whileTrue: [ 
		minTree := self reduce: minTree at: index with: bound.
		attemps := attemps + 1.
		( minTree treeSize = prevByMain treeSize ) ifTrue: [ 
		index := index + 1.
		attemps := 0.
		] 
	].
	
	( minTree treeSize < prevByMain treeSize ) ifTrue: [ 
		attemps := 0.
	]. 

	( attemps > limit ) ifTrue: [ 
		index := index + 1.
		attemps := 0.
	].
    
    ^ minTree
]

{ #category : 'accessing' }
UmeVulcanShrinker >> oracle: aOracle [

	oracle := aOracle.
	mainReducer oracle: aOracle.
	subtreeShrinker oracle: aOracle.
	identidierShrinker oracle: aOracle
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduce: aTree at: index with: bound [

	( index = 1 ) ifTrue: [ ^ self subtreeReplacement: aTree bound: bound ].
	( index = 2 ) ifTrue: [ ^ self identifierRemplacement: aTree bound: bound ].
	( index = 3 ) ifTrue: [ ^ self treeBasedLEE: aTree bound: bound ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduce: aTree bound: bound [

	^ mainReducer minimizeOne: aTree upperBound: bound 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> removeNodes: subsetToRemove fromTree: aTree [

	subsetToRemove do: [ :node |
		node parent ifNotNil: [ :p | p removeChild: node ].
	].

	^ aTree
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

	^ subtreeShrinker minimizeOne: aTree upperBound: bound 

]

{ #category : 'accessing' }
UmeVulcanShrinker >> treeBasedLEE: aTree bound: bound [

	| t level nodeSequence |

	t := aTree.
	level := 0.
	nodeSequence := { aTree root}. 
	
	[ nodeSequence size < windowSize and: [ nodeSequence isNotEmpty ] ] whileTrue: [
	level := level + 1. 
		nodeSequence := t allNodesAtLevel: level.
	].

	nodeSequence size < windowSize ifTrue: [ ^ t ].

	1 to: (nodeSequence size - windowSize +1 ) do: [ :windowPosition | 
		| nodeSet properSubsets |
		nodeSet := nodeSequence copyFrom: windowPosition to: (windowPosition + windowSize - 1).
		properSubsets := self generateProperSubsetsOf: nodeSet.
		properSubsets do: [ :subsetToRemove |
			| backup  |
			backup := Dictionary new. 
			subsetToRemove do: [ :node |
				node parent ifNotNil: [ :p |
					backup at: p ifAbsentPut: [ p children copy ].
				] 
			].
			subsetToRemove do: [ :node |
				node parent ifNotNil: [ :p | p removeChild: node ]. 
			].
			(self triggerBug: t upperBound: bound ) ifTrue: [ 
				^ t
			].
			backup associationsDo: [ :parentAndchildren |
				| parent children |
				parent := parentAndchildren key.
				children := parentAndchildren value
				parent children: children.
			]
		].
	].

	^ t
]
