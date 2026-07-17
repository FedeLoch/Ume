Class {
	#name : 'UmePersesShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'candidates'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'initialization' }
UmePersesShrinker >> initialize [ 

	super initialize.
	candidates := Heap sortBlock: [ :node1 :node2 |
		node1 treeHeight < node2 treeHeight
	]
]

{ #category : 'shrinking' }
UmePersesShrinker >> minimizeOne: givenTree upperBound: bound [

	| best |
	
	best := self tree: givenTree asInput.
	candidates add: best.
	
	[ candidates isNotEmpty ] whileTrue: [ | node |
		node := candidates removeFirst.
		self reduceNode: node upperBound: bound.
		node children do: [ :child | candidates add: child ]
	].
	
	^ best
]

{ #category : 'as yet unclassified' }
UmePersesShrinker >> reduceKleene: node upperBound: bound [

	1 halt.
]

{ #category : 'shrinking' }
UmePersesShrinker >> reduceNode: node upperBound: bound [
	
	"A -> a*"
	node isKleene ifTrue: [ ^ self reduceKleene: node upperBound: bound ].
	
	"A -> a+"
	node isPlus ifTrue: [ ^ self reducePlus: node upperBound: bound ].
	
	"A -> a?"
	node isOptional ifTrue: [ ^ self reduceOptional: node upperBound: bound ].
	
	^ self reduceRegular: node upperBound: bound
]

{ #category : 'shrinking' }
UmePersesShrinker >> reduceOptional: node upperBound: bound [

	1 halt.
]

{ #category : 'shrinking' }
UmePersesShrinker >> reducePlus: node upperBound: bound [
	1 halt.
]

{ #category : 'shrinking' }
UmePersesShrinker >> reduceRegular: node upperBound: bound [
	 1 halt.
]

{ #category : 'shrinking' }
UmePersesShrinker >> shouldStop: minimized size: size from: currentTree size: currentSize [

	1 halt.
]
