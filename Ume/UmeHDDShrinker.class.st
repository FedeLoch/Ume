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
UmeHDDShrinker >> hddmin: tree upperBound: bound level: level [
	
		| candidates |
		
		candidates := tree allNodesAtLevel: level.
		(candidates size <= 1) ifTrue: [ ^ nil ].
		
		1 to: (candidates size) do: [ :k |
			candidates combinations: k atATimeDo: [ :toMinimize |
				(seen includes: toMinimize) ifFalse: [ 
					seen add: toMinimize.
					self minimizationDone.
					(self hddmin: tree withSubset: toMinimize bound: bound) ifTrue: [ ^ nil ] ifFalse: [
						self failedMinimization.
					]
				]
			]
		]
]

{ #category : 'shrinking' }
UmeHDDShrinker >> hddmin: tree withSubset: toMinimize bound: bound [

	| reduced parents |
	
	reduced := false.
	parents := Dictionary new.

	toMinimize do: [ :node | | parent |
		parent := node parent.
		parent ifNotNil: [
			"saving parents with original children to revert later"
			parents at: parent ifAbsentPut: [ parent children copy ].
			parent removeChild: node
		]
	].

	reduced := self triggerBug: tree upperBound: bound.
	
	reduced ifFalse: [
		parents associationsDo: [ :parentAndchildren | | parent children |
			parent := parentAndchildren key.
			children := parentAndchildren value. 
			parent children: children.
		].
	]"ifTrue: [
		tree children: (self copyTree: tree) children
	].".
	
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

	currentLevel := tree treeHeight - 1.
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
