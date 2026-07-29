Class {
	#name : 'UmeVulcanShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'mainReducer'
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
UmeVulcanShrinker >> mainReducer: aReducer [

	mainReducer := aReducer 
]

{ #category : 'shrinking' }
UmeVulcanShrinker >> minimizeOne: originalTree upperBound: bound [

	| minTree index attemps prevByMain |
	
	minTree := originalTree.
	index := 0.
	attemps := 0.
	
	prevByMain := minTree.
	minTree := self reduce: minTree.
	[ minTree treeSize < prevByMain treeSize ] ifTrue: [
		attemps := 0.
		prevByMain := minTree 
	 ].
	[ (minTree = prevByMain) and: index < self auxiliaryReducers size ] whileTrue: [ 
		minTree := self reduce: minTree at: index. 
		 ]
]

{ #category : 'accessing' }
UmeVulcanShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
	
]
