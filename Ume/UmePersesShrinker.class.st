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

{ #category : 'as yet unclassified' }
UmePersesShrinker >> ddmin: node upperBound: bound minSize: minSize [

	| allChildren granularity currentNode |
	
	currentNode := node.
	allChildren := node children.
	granularity := 2.

	[allChildren size >= minSize ] whileTrue: [ | start subsetLength someComplementFailing |
		start := 0.
		subsetLength := allChildren size // granularity.
		someComplementFailing := false.
		[ start < allChildren size ] whileTrue: [ | complement savedChildren |
			self minimizationDone.
			complement := self getComplement: allChildren start: start length: subsetLength .
			savedChildren := node children copy.
			node children: complement.
			
			(self triggerBug: currentNode root upperBound: bound ) ifTrue: [
				allChildren := complement.
				granularity := (granularity -1) max: 2.
				someComplementFailing := true.
				start := allChildren size.
			] ifFalse: [
				node children: savedChildren.
				self failedMinimization.
				start := start + subsetLength
			]
		].
		
		someComplementFailing ifFalse: [ 
			(granularity = allChildren size) ifTrue:[ ^ allChildren ].
			granularity := (granularity*2) min: allChildren size
		 ]
	]
]

{ #category : 'shrinking' }
UmePersesShrinker >> getComplement: input start: start length: subsetLength [

	^ (input copyFrom: 1 to: start), (input copyFrom: (start + subsetLength + 1 min: input size + 1) to: input size)
]

{ #category : 'shrinking' }
UmePersesShrinker >> grammar: aGrammar [

	super grammar: (aGrammar asPNF)
]

{ #category : 'initialization' }
UmePersesShrinker >> initialize [ 

	super initialize.
	candidates := Heap sortBlock: [ :node1 :node2 |
		node1 treeHeight > node2 treeHeight
	]
]

{ #category : 'shrinking' }
UmePersesShrinker >> minimizeOne: givenTree upperBound: bound [

	| best |
	
	best := self tree: givenTree asInput.
	candidates add: best.
	
	[ candidates isNotEmpty ] whileTrue: [ | largerNode |
		largerNode := candidates removeFirst.
		self reduceNode: largerNode upperBound: bound.
		largerNode children do: [ :child | candidates add: child ]
	].
	
	^ best
]

{ #category : 'shrinking' }
UmePersesShrinker >> reduceNode: node upperBound: bound [
	
	"A -> a*"
	node isStar ifTrue: [ ^ self reduceStar: node upperBound: bound ].
	
	"A -> a+"
	node isPlus ifTrue: [ ^ self reducePlus: node upperBound: bound ].
	
	"A -> a?"
	node isOptional ifTrue: [ ^ self reduceOptional: node upperBound: bound ].
	
	^ self reduceRegular: node upperBound: bound
]

{ #category : 'as yet unclassified' }
UmePersesShrinker >> reduceOptional: node upperBound: bound [

	^ self reduceStar: node upperBound: bound
]

{ #category : 'as yet unclassified' }
UmePersesShrinker >> reducePlus: node upperBound: bound [

	^ self ddmin: node upperBound: bound minSize: 1
]

{ #category : 'shrinking' }
UmePersesShrinker >> reduceRegular: node upperBound: bound [

	" we try to replace by one of his children 
		2 option: 
			- same rule
			- matching rule 
	"
]

{ #category : 'as yet unclassified' }
UmePersesShrinker >> reduceStar: node upperBound: bound [

	^ self ddmin: node upperBound: bound minSize: 0
]

{ #category : 'shrinking' }
UmePersesShrinker >> shouldStop: minimized size: size from: currentTree size: currentSize [

	^ minimized asInput = currentTree asInput
]
