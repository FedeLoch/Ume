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
UmeHDDShrinker >> ddMin: subTrees upperBound: bound level: level currentTree: tree [

	| currentInput granularity start subsetLength someComplementFailing |

	currentInput := subTrees .
	granularity := 2.

	[currentInput size >= 2 ] whileTrue: [
		start:= 0.
		subsetLength := currentInput size // granularity.
		someComplementFailing := false.
		[ start < currentInput size ] whileTrue: [ | minimizeNode complement testTree |
			self minimizationDone.
			complement := self getComplement: currentInput start: start length: subsetLength .
			minimizeNode := currentInput select: [ :node | complement includes: node ].
			
			minimizeNode do: [ :node | | parent |
				parent := node parent. 
				1 halt.
				parent replaceChild: node by: (self minimized: node) ].
			
			"testTree := self removeIrrevelantNodes: tree level: level  with: complement."
			(self triggerBug: currentInput upperBound: bound ) ifTrue: [ 
				currentInput := complement.
				granularity := (granularity -1) max: 2.
				someComplementFailing := true.
				start := currentInput size.
			] ifFalse: [
				self failedMinimization.
				minimizeNode do: [ :node | | parent |
					parent := node parent. 
					parent replaceChildAt: node index with: node]. 
				start := start + subsetLength
			]
		].
		
		someComplementFailing ifFalse: [ 
			(granularity = currentInput size) ifTrue:[
				^ currentInput ].
			granularity := (granularity*2) min: currentInput size.
		 ]
	].

	^ currentInput
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
UmeHDDShrinker >> getComplement: input start: start length: subsetLength [

	| complement |
	complement := (input copyFrom: 1 to: start) , 
                 (input copyFrom: (start + subsetLength + 1 min: input size + 1) to: input size).

	^ complement. 
]

{ #category : 'shrinking' }
UmeHDDShrinker >> minimizeOne: originalTree upperBound: bound [

	| level levelMax currentTree nodesAtLevel minconfig |
	currentTree := originalTree. 
	level := 1.
	levelMax := currentTree treeHeight.
	[ level <= levelMax ] whileTrue: [ 
		nodesAtLevel := currentTree allNodesAtLevel: level.
		(nodesAtLevel size >= 2) ifTrue: [ 
			minconfig :=  self ddMin: nodesAtLevel upperBound: bound level: level currentTree: currentTree.
			currentTree := self removeIrrevelantNodes: currentTree level: level with: minconfig.
		].
		level := level + 1.
		levelMax := currentTree treeHeight.
	].
	^ currentTree
]

{ #category : 'testing' }
UmeHDDShrinker >> removeIrrevelantNodes: tree level: level with: nodes [

	| treeCopy |
	
	treeCopy := self copyTree: tree.
	( level = 0 ) ifTrue: [ ^ treeCopy ].
	
	^ self filter2: treeCopy level: 1 to: level with: nodes
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
