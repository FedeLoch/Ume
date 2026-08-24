Class {
	#name : 'UmeVulcanShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'mainReducer',
		'auxiliaryReducers',
		'limit',
		'windowSize'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeVulcanShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'accessing' }
UmeVulcanShrinker >> auxiliaryReducers [ 

	^auxiliaryReducers 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> grammar: aGrammar [

	super grammar: aGrammar. 
	mainReducer grammar: aGrammar.
	auxiliaryReducers do: [ :reducer |
		reducer grammar: aGrammar ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> initialize [

	super initialize.
	
	maxIterations := 1.
	windowSize := 4. 
	
	mainReducer := UmeHDDShrinker new.
	auxiliaryReducers := { 
		UmeIdentifierReplacement new. 
		UmeSubTreeReducer new.
		UmeTreeBasedLEE new }
]

{ #category : 'accessing' }
UmeVulcanShrinker >> mainReducer: aReducer [

	mainReducer := aReducer.
	mainReducer grammar: grammar. 
]

{ #category : 'shrinking' }
UmeVulcanShrinker >> minimizeOne: originalTree upperBound: bound [

	| minimumInput index |
	
	minimumInput := self copyTree: originalTree.
	index := 1.
	
	[ index <= auxiliaryReducers size ] whileTrue: [
		| startingSize result |
		startingSize := minimumInput treeSize. 
		
		"Main reducer"
		minimumInput := self reduceMain: minimumInput bound: bound.
		self minimizationDone.
		
		"Auxiliary reducers"
		result := self runAuxiliary: minimumInput startingAt: index  bound: bound.
		minimumInput := result key.
		index := result value.  
		
		"if we don't find smaller input, we stop"
		(minimumInput treeSize = startingSize ) ifTrue: [ ^ minimumInput ].
	].
	^ minimumInput
]

{ #category : 'accessing' }
UmeVulcanShrinker >> oracle: aOracle [

	super oracle: aOracle. 
	mainReducer oracle: aOracle.
	auxiliaryReducers do: [ :reducer |
		reducer oracle: aOracle ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduceAuxiliary: reducer on: aTree bound: bound [

	| candidate prevSize |
	
	prevSize := aTree treeSize.
	candidate := reducer reduce: aTree bound: bound.
	self minimizationDone.
	
	^ (candidate treeSize < prevSize ) ifTrue: [ candidate ] ifFalse: [ self failedMinimization. aTree ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> reduceMain: aTree bound: bound [

	^ mainReducer minimizeOne: aTree upperBound: bound 
]

{ #category : 'accessing' }
UmeVulcanShrinker >> runAuxiliary: aTree startingAt: aIndex bound: bound [

	| currentTree index haveReduce|
	
	currentTree := aTree.
	index := aIndex.
	haveReduce := false.
	
	[  (index <= auxiliaryReducers size) and: [ haveReduce not ] ] whileTrue: [ 
		| reducer candidate prevSize |
		reducer := auxiliaryReducers at: index. 
		prevSize := currentTree treeSize.
		candidate := self reduceAuxiliary: reducer on: currentTree bound: bound.
		
		(candidate treeSize < prevSize ) ifTrue: [ 
			currentTree := candidate.
			haveReduce := true.
		] ifFalse: [ 
			index := index + 1
		]
	].

	^ currentTree -> index "we return the new tree and the new index"
]

{ #category : 'accessing' }
UmeVulcanShrinker >> setWindowSize: aSize [

	windowSize := aSize.
	(auxiliaryReducers at:3) windowSize: aSize
]

{ #category : 'accessing' }
UmeVulcanShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
	
]
