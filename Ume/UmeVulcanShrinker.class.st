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

	| minimumInput index prevInputByMain attempts |
	
	minimumInput := self copyTree: originalTree.
	index := 1.
	attempts := 0.
	
	[ true ] whileTrue: [

		"Main reducer"
		prevInputByMain := self copyTree: minimumInput.	
		minimumInput := self reduceMain: minimumInput bound: bound.
		self minimizationDone.
		( minimumInput treeSize < prevInputByMain treeSize ) ifTrue: [
			attempts := 0.
			prevInputByMain := self copyTree: minimumInput.
	 	] ifFalse: [ self failedMinimization ].
	
		"Auxiliary reducer"	
		[ (minimumInput treeSize = prevInputByMain treeSize ) and: [ index <= auxiliaryReducers size] ] whileTrue: [
			| reducer | 
			reducer := auxiliaryReducers at: index. 
			minimumInput := reducer reduce: minimumInput bound: bound.
			self minimizationDone.
			attempts := attempts + 1.
			( minimumInput treeSize = prevInputByMain treeSize ) ifTrue: [ 
				self failedMinimization.
				index := index + 1.
				attempts := 0.
			]
		].
	
		( minimumInput treeSize < prevInputByMain treeSize) ifTrue: [ 
			attempts := 0
		] ifFalse: [ (attempts > limit ) ifTrue: [ 
			index := index + 1. "go to the next one " 
			attempts:= 0 
			]
		].
	
		(index >= 3 ) ifTrue: [ ^ minimumInput ].
	].
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
