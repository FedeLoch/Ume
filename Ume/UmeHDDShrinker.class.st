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
UmeHDDShrinker >> getComplement: candidates start: start length: segmentSize [

	| firstSlice secondSlice|

	firstSlice := candidates takeFirst: start.
	secondSlice := ((start + segmentSize + 1 min: candidates size + 1) to: candidates size) collect: [ :index | candidates at: index ].

	^ firstSlice asOrderedCollection, secondSlice
]

{ #category : 'shrinking' }
UmeHDDShrinker >> hddmin: tree upperBound: bound level: level [
	
		| candidates granularity |
		
		candidates := tree allNodesAtLevel: level.
		(candidates size <= 1) ifTrue: [ ^ nil ].
		
		granularity := 2.
		
		[ candidates size > 1 ] whileTrue: [ | start segmentSize anyComplementFailing |
			start:= 0.
			segmentSize := (candidates size // granularity) max: 1.
			anyComplementFailing := false.
			
			[ start < candidates size ] whileTrue: [ | complement toMinimize parents rootChildren |
				self minimizationDone. 
			
				complement := self getComplement: candidates start: start length: segmentSize.
				toMinimize := candidates \ complement.
				
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
			
				(self triggerBug: tree upperBound: bound ) ifTrue: [
					candidates := complement.
					granularity := (granularity -1) max: 2.
					anyComplementFailing := true.
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
					
					start := start + segmentSize.
				]
			].
		
			anyComplementFailing ifFalse: [ 
				(granularity = candidates size) ifTrue: [ ^ nil ].
				granularity := (granularity * 2) min: candidates size.
		 	]
			
		]
]

{ #category : 'shrinking' }
UmeHDDShrinker >> initialize [ 

	super initialize.
	seen := Set new.
]

{ #category : 'shrinking' }
UmeHDDShrinker >> minimizeOne: originalTree upperBound: bound [

	| level maxLevel tree |

	tree := self tree: originalTree asInput.

	maxLevel := tree treeHeight.
	level := maxLevel.
   [ level >= 1 ] whileTrue: [ 
		self hddmin: tree upperBound: bound level: level.		
		level := level - 1.
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
