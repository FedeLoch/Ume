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
UmeVulcanShrinker >> findFirstNodeLevel: currentTree [

	| nodeSequence currentTreeLevel |
	
	currentTreeLevel := 0.
	nodeSequence := {currentTree root}.
	[nodeSequence size < windowSize and: [ nodeSequence isNotEmpty ] ]whileTrue: [
		currentTreeLevel := currentTreeLevel + 1. 
		nodeSequence := currentTree allNodesAtLevel: currentTreeLevel.
	].

	( nodeSequence size < windowSize ) ifTrue: [ currentTreeLevel := nil ]. 

	^ currentTreeLevel. 

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
	limit := 100. 
	windowSize := 4. 
	
	mainReducer := UmeHDDShrinker new.
	auxiliaryReducers := { 
		UmeIdentifierReplacement new. 
		UmeSubTreeReducer new.
		UmeTreeBasedLEE new }
]

{ #category : 'accessing' }
UmeVulcanShrinker >> limit: aNumber [

	limit := aNumber 
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
		| startingSize reduceByAux|

		"Main reducer"
		startingSize := minimumInput treeSize. 
		minimumInput := self reduceMain: minimumInput bound: bound.
		self minimizationDone.
		
		"Auxiliary reducer"
		reduceByAux := false. 
		
		[ (index <= auxiliaryReducers size) and: [ reduceByAux not ] ] whileTrue: [
			| reducer candidate | 
			reducer := auxiliaryReducers at: index.
			candidate := reducer reduce: minimumInput bound: bound.
			self minimizationDone.
			1 halt. 
			( candidate treeSize < minimumInput treeSize ) ifTrue: [ 
				minimumInput := candidate.
				reduceByAux := true
			] ifFalse: [ 
				self failedMinimization.
				index := index + 1
			]
		].
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
UmeVulcanShrinker >> reduceMain: aTree bound: bound [

	^ mainReducer minimizeOne: aTree upperBound: bound 
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
