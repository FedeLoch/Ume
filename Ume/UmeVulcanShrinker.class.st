Class {
	#name : 'UmeVulcanShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'mainReducer',
		'auxiliaryReducers',
		'windowSize'
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
UmeVulcanShrinker >> auxiliaryReducers [

	^ auxiliaryReducers 
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
UmeVulcanShrinker >> initialize [

	super initialize.
	auxiliaryReducers add: UmeSimplifyGrammarSubtreeReducer new. 
	auxiliaryReducers add: UmeSimplifyGrammarSubtreeReducer new. 
	
	windowSize := 4. 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> mainReducer: aReducer [

	mainReducer := aReducer 
]

{ #category : 'shrinking' }
UmeVulcanShrinker >> minimizeOne: originalTree upperBound: bound [

	| minTree index attemps prevByMain |
	
	minTree := originalTree.
	index := 0.
	attemps := 0.
	
	prevByMain := minTree.
	minTree := self reduce: minTree.
	
	[ minTree treeSize < prevByMain treeSize ] ifTrue: [
		attemps := 0.
		prevByMain := minTree 
	 ].

	[ (minTree = prevByMain) and: index < self auxiliaryReducers size ] whileTrue: [ 
		minTree := self reduce: minTree at: index. 
		 ].
	
	[ minTree treeSize < prevByMain treeSize ] ifTrue: [ 
		attemps := 0.
	] ifFalse: [ 
		index := index + 1.
		attemps := 0.
	].

	[ index >= auxiliaryReducers size ] ifTrue: [ ^ minTree ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduce: aTree [

]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduce: aTree at: index [ 

]

{ #category : 'accessing' }
UmeVulcanShrinker >> removeNodes: subsetToRemove fromTree: aTree [
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
		nodeSet := nodeSequence copyFrom: windowPosition to: (windowPosition + windowPosition - 1).
		properSubsets := self generateProperSubsetsOf: nodeSet.
		properSubsets do: [ :subsetToRemove |
			| candidateTree |
			candidateTree := self removeNodes: subsetToRemove fromTree: t.
			(self triggerBug: candidateTree upperBound: bound ) ifTrue: [ 
				^ candidateTree
			] 
		]
	].

	^ t
]
