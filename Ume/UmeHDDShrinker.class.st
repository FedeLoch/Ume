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

{ #category : 'testing' }
UmeHDDShrinker >> ddMin2: nodesAtLevel upperBound: bound level: level currentTree: tree [

	| candidates granularity start subsetLength someComplementFailing |

	candidates := nodesAtLevel .
	granularity := 2.

	[ candidates size > 1 ] whileTrue: [
		start:= 0.
		subsetLength := candidates size // granularity.
		someComplementFailing := false.

		[ start < candidates size ] whileTrue: [ | nodesToMinimize complement parents rootChildren |
			self minimizationDone.
			
			"these two lines can be extracted on a method"
			complement := self getComplement: candidates start: start length: subsetLength.
			nodesToMinimize := candidates reject: [ :node | complement includes: node ].
			
			parents := Dictionary new.
			nodesToMinimize do: [ :node |
				node parent ifNotNil: [ :p |
					parents at: p ifAbsentPut: [ p children copy ]
				] 
			].

			nodesToMinimize do: [ :node | | parent currentIndex |
				parent := node parent.
				parent ifNotNil: [ 
					currentIndex := parent indexOf: node.
					currentIndex > 0 ifTrue: [ parent removeChildAt: currentIndex ] 
				].
				rootChildren := node children copy.
				node children: OrderedCollection new. 
			].
			
			(self triggerBug: tree upperBound: bound ) ifTrue: [
				candidates := complement.
				granularity := (granularity -1) max: 2.
				someComplementFailing := true.
				start := candidates size.
			] ifFalse: [
				self failedMinimization.
				
				parents associationsDo: [ :parentAndchildren | | parent children |
					parent := parentAndchildren key.
					children := parentAndchildren value. 
					parent children: children. 
				].
				rootChildren ifNotNil: [ 
					tree children: rootChildren.
					rootChildren := nil.
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
UmeHDDShrinker >> ddMin: nodesAtLevel upperBound: bound level: level currentTree: tree [

	| candidates granularity start subsetLength someComplementFailing minimizedList |

	candidates := nodesAtLevel .
	granularity := 2.

	[ candidates size > 1 ] whileTrue: [
		start:= 0.
		subsetLength := candidates size // granularity.
		someComplementFailing := false.

		[ start < candidates size ] whileTrue: [ | nodesToMinimize complement rootChildren |
			self minimizationDone.
			
			"these two lines can be extracted on a method"
			complement := self getComplement: candidates start: start length: subsetLength.
			nodesToMinimize := candidates reject: [ :node | complement includes: node ].
			
			minimizedList := nodesToMinimize collect: [ :node | | parent minimized |
				parent := node parent.
				minimized := self minimized: node.
				parent ifNotNil: [	
					parent replaceChild: node by: minimized
				] ifNil: [
					rootChildren := node children.
					node children: minimized children.
				].
				minimized	
			].
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
					parent ifNotNil: [ parent replaceChild: current by: node ] ifNil: [
						node children: rootChildren
					]
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

{ #category : 'shrinking' }
UmeHDDShrinker >> getComplement: candidates start: start length: segmentSize [

	| firstSlice secondSlice|
	firstSlice := (1 to: start) collect: [ :index | candidates at: index ].
	secondSlice := ((start + segmentSize + 1 min: candidates size + 1) to: candidates size) collect: [ :index | candidates at: index ].

	^ firstSlice asOrderedCollection, secondSlice
]

{ #category : 'shrinking' }
UmeHDDShrinker >> initialize [ 

	super initialize.
	seen := Set new.
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
			self ddMin2: nodesAtLevel upperBound: bound level: level currentTree: tree.
		].
		
		level := level + 1.
		maxLevel := tree treeHeight.
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
