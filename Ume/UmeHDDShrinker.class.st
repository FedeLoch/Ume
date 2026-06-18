Class {
	#name : 'UmeHDDShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'ddMin'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeHDDShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'testing' }
UmeHDDShrinker >> checkGrammar: aInput [

	^ UmeGrammarParser accept: aInput from: grammar
]

{ #category : 'testing' }
UmeHDDShrinker >> copyTree: tree [
 
	^ self tree: tree asInput
]

{ #category : 'testing' }
UmeHDDShrinker >> ddMin: nodesAtLevel upperBound: bound level: level currentTree: tree [

	| candidates granularity start subsetLength someComplementFailing minimizedList |

	candidates := nodesAtLevel .
	granularity := 2.

	[ candidates size > 1 ] whileTrue: [
		start:= 0.
		subsetLength := candidates size // granularity.
		someComplementFailing := false.

		[ start < candidates size ] whileTrue: [ | nodesToMinimize complement |
			self minimizationDone.
			
			"these two lines can be extracted on a method"
			complement := self getComplement: candidates start: start length: subsetLength.
			nodesToMinimize := candidates reject: [ :node | complement includes: node ].
			
			minimizedList := nodesToMinimize collect: [ :node | | parent minimized |
				parent := node parent.
				parent ifNotNil: [
					minimized := self minimized: node.
					parent replaceChild: node by: minimized.
					minimized	
				] ifNil: [ node ]
			].
		
			"testTree := self removeIrrevelantNodes: tree level: level  with: complement."
			(self triggerBug: tree upperBound: bound ) ifTrue: [
				candidates := complement.
				granularity := (granularity -1) max: 2.
				someComplementFailing := true.
				start := candidates size.
			] ifFalse: [
				self failedMinimization.
				nodesToMinimize doWithIndex: [ :node :index | | parent current |
					current := minimizedList at: index.
					parent := current parent.
					parent ifNotNil: [ parent replaceChild: current by: node ]
				]. 
				start := start + subsetLength
			]
		].
		
		someComplementFailing ifFalse: [ 
			(granularity = candidates size) ifTrue: [ ^ nil ].
			granularity := (granularity * 2) min: candidates size.
		 ]
	]
]

{ #category : 'testing' }
UmeHDDShrinker >> filter2: tree level: currentLevel to: level with: nodes [

	| nodeCopy |
	nodeCopy := tree copy .
	tree children ifNil: [ ^ nodeCopy ].
	
	currentLevel = level ifTrue: [ | filterChild |
		filterChild := tree children select: [ :child | nodes includes: child ].
		nodeCopy children: filterChild.
		^ nodeCopy. 
	].
	nodeCopy children: ( tree children collect: [ :child |
		(child isLeaf) ifFalse: [
			self filter: child level: currentLevel+1 to: level  with: nodes] ]).
	^ nodeCopy
]

{ #category : 'testing' }
UmeHDDShrinker >> filter: tree level: currentLevel to: level with: nodes [

	| nodeCopy |
	nodeCopy := tree copy .
	tree children ifNil: [ ^ nodeCopy ].
	
	currentLevel = level ifTrue: [ | filterChild |
		filterChild := nodeCopy children select: [ :child | (nodes includes: child) not ].
		filterChild do: [ :child | | minimized |
			minimized := self minimized: child.
			child parent replaceChild: child by: minimized.
		].
		^ nodeCopy. 
	].
	nodeCopy children: ( tree children collect: [ :child |
		(child isLeaf) ifFalse: [
			self filter: child level: currentLevel+1 to: level  with: nodes] ]).
	^ nodeCopy
]

{ #category : 'shrinking' }
UmeHDDShrinker >> getComplement: candidates start: start length: segmentSize [

	| firstSlice secondSlice|
	firstSlice := (1 to: start) collect: [ :index | candidates at: index ].
	secondSlice := ((start + segmentSize + 1 min: candidates size + 1) to: candidates size) collect: [ :index | candidates at: index ].

	^ firstSlice asOrderedCollection addAll: secondSlice
]

{ #category : 'shrinking' }
UmeHDDShrinker >> minimizeOne: originalTree upperBound: bound [

	| level maxLevel tree nodesAtLevel |

	tree := self tree: originalTree asInput.
	level := 1.
	maxLevel := tree treeHeight.
	[ level <= maxLevel ] whileTrue: [ 
		nodesAtLevel := tree allNodesAtLevel: level.
		(nodesAtLevel size > 1) ifTrue: [
			self ddMin: nodesAtLevel upperBound: bound level: level currentTree: tree
		].

		level := level + 1.
		maxLevel := tree treeHeight.
	].

	^ tree
]

{ #category : 'shrinking' }
UmeHDDShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]

{ #category : 'testing' }
UmeHDDShrinker >> triggerBug: aTree upperBound: _ [

	|input|
	
	input := (self asInput: aTree).
	(self checkGrammar: input ) ifFalse: [ ^ false ].

	^ oracle accepts: input from: _ 
]
