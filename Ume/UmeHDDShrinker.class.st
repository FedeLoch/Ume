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
UmeHDDShrinker >> getComplement: input start: start length: subsetLength [

	| complement |
	complement := (input copyFrom: 1 to: start) , 
                 (input copyFrom: (start + subsetLength + 1 min: input size + 1) to: input size).

	^ complement 
]

{ #category : 'shrinking' }
UmeHDDShrinker >> hddmin: tree removeNodes: nodesToRemove bound: bound [

	| reduced parents |
	
	reduced := false.
	parents := Dictionary new.

	nodesToRemove do: [ :node | | parent |
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
	]ifTrue: [
		tree children: (self copyTree: tree) children
	].
	
	^ reduced
]

{ #category : 'shrinking' }
UmeHDDShrinker >> hddmin: tree upperBound: bound level: level [
	
		| candidates granularity |

		candidates := tree allNodesAtLevel: level.
		(candidates size <= 1) ifTrue: [ ^ nil ].
		granularity := 2.
		
		[ granularity <= candidates size ] whileTrue: [ 
			| start subsetLength someComplementFailing |
			start := 0.
			subsetLength := (candidates size // granularity) max: 1.
			someComplementFailing := false.
			[ start < candidates size ] whileTrue: [ | complement nodesToRemove |
				self minimizationDone.
				complement := self getComplement: candidates start: start length: subsetLength .
				nodesToRemove := candidates reject: [ :node | complement includes: node ].
				(self hddmin: tree removeNodes: nodesToRemove bound: bound) ifTrue: [ 
					candidates := complement.
					granularity := (granularity -1) max: 2.
					someComplementFailing := true.
					start := candidates size.
				] ifFalse: [
					self failedMinimization.
					start := start + subsetLength.
				]
			].
			someComplementFailing ifFalse: [
				granularity = candidates size ifTrue: [ ^ nil ].
				granularity := (granularity * 2) min: candidates size 
			].
		].

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

	currentLevel := 1.
	
   [ currentLevel <= tree treeHeight ] whileTrue: [ 
		self hddmin: tree upperBound: bound level: currentLevel.		
		currentLevel := currentLevel + 1.
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
