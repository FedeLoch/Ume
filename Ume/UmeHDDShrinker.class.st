Class {
	#name : 'UmeHDDShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'ddMin',
		'seen'
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

{ #category : 'shrinking' }
UmeHDDShrinker >> hddmin: tree upperBound: bound level: level [
	
		| candidates |
		
		candidates := tree allNodesAtLevel: level.
		(candidates size <= 1) ifTrue: [ ^ nil ].
		
		1 to: (candidates size -1) do: [ :k |
			candidates combinations: k atATimeDo: [ :toMinimize |
				self minimizationDone.
				(self hddmin: tree withSubset: toMinimize bound: bound) ifTrue: [ ^ nil ]
			]
		]
]

{ #category : 'shrinking' }
UmeHDDShrinker >> hddmin: tree withSubset: toMinimize bound: bound [

	| reduced parents rootChildren |
	
	reduced := false.
	parents := Dictionary new.
	toMinimize do: [ :node |
		node parent ifNotNil: [ :parent |
			parents at: parent ifAbsentPut: [ parent children copy ]
		]
	].

	toMinimize do: [ :node | | parent currentIndex |
		parent := node parent.
		parent ifNotNil: [ 
			currentIndex := parent children indexOf: node.
			currentIndex > 0 ifTrue: [ parent removeChildAt: currentIndex ] 
		] ifNil: [
			rootChildren := node children.
			node children: OrderedCollection new.
		] 
	].

	reduced := self triggerBug: tree upperBound: bound.
	
	reduced ifFalse: [
		self failedMinimization.
				
		parents associationsDo: [ :parentAndchildren | | parent children |
			parent := parentAndchildren key.
			children := parentAndchildren value. 
			parent children: children. 
		].
				
		rootChildren ifNotNil: [ 
			tree children: rootChildren.
			rootChildren := nil.
		]
	].
	
	^ reduced
]

{ #category : 'shrinking' }
UmeHDDShrinker >> initialize [ 

	super initialize.
	seen := Set new.
]

{ #category : 'shrinking' }
UmeHDDShrinker >> minimizeOne: originalTree upperBound: bound [

	| currentLevel tree |

	tree := self tree: originalTree asInput.

	currentLevel := tree treeHeight.
   [ currentLevel >= 1 ] whileTrue: [ 
		self hddmin: tree upperBound: bound level: currentLevel.		
		currentLevel := currentLevel - 1.
	].

	^ tree
]

{ #category : 'shrinking' }
UmeHDDShrinker >> seen [

	^ seen
]

{ #category : 'shrinking' }
UmeHDDShrinker >> seen: aInput [

	seen := aInput 
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
