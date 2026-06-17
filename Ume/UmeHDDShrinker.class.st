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
		[ start < currentInput size ] whileTrue: [ | complement testTree |
			self minimizationDone.
			complement := self getComplement: currentInput start: start length: subsetLength .
			testTree := self removeIrrevelantNodes: currentInput level: level  with: complement.
			(self triggerBug: testTree upperBound: bound ) ifTrue: [ 
				currentInput := complement.
				granularity := (granularity -1) max: 2.
				someComplementFailing := true.
				start := currentInput size.
			] ifFalse: [
				self failedMinimization.
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
			minconfig :=  self ddMin: nodesAtLevel  upperBound: bound level: level currentTree: currentTree.
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
	nodes do: [ :node | | index |
		index := tree indexOf: node.
		treeCopy removeChildAt: index. ]. 
	
	^ treeCopy
]

{ #category : 'testing' }
UmeHDDShrinker >> triggerBug: aTree upperBound: _ [

	|input|
	
	input := (self asInput: aTree).
	(self checkGrammar: input ) ifFalse: [ ^ false ].

	^ oracle accepts: input from: _ 
]
