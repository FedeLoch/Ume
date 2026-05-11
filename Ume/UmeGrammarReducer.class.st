Class {
	#name : 'UmeGrammarReducer',
	#superclass : 'UmeShrinker',
	#instVars : [
		'grammar'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGrammarReducer >> alternateReductions: aTree symbol: aSymbol [

	| reduction expansion |
	reduction := OrderedCollection new. 
	expansion := grammar get: aSymbol .
]

{ #category : 'shrinking' }
UmeGrammarReducer >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGrammarReducer >> minimizeOne: tree upperBound: bound [

	| allNodes reduced |
	allNodes := tree allNodes asSet.
	reduced := false. 
	
	allNodes  do: [ :node | |parent reducedChild symbol index|
		reducedChild := false.
		parent := node parent. 
		symbol := node symbol. 
		(self symbolReduction: tree for: symbol ) do: [ :reduction |
			 	( reduction size >= node size ) ifTrue: [ 
					index := parent children indexof: node.
					parent replaceChildAt: index with: reduction ].
					(self triggerBug: tree upperBound: bound) ifTrue: [ 
						reduced:= reducedChild := true. 
					]]"ajouter le else"
				].
	^ tree 
	
]

{ #category : 'shrinking' }
UmeGrammarReducer >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'shrinking' }
UmeGrammarReducer >> possibleCombinations: aList [
	
	| res |
	((aList size) equals: 0) ifTrue: [^nil]. 
	res:= OrderedCollection new.
	
]

{ #category : 'shrinking' }
UmeGrammarReducer >> subTreeWithSymbol: aTree symbol: aSymbol [

	| res children|
	
	res := OrderedCollection new.
	children := aTree allNodes.
	((children symbol) equals: aSymbol ) ifTrue: [ res add: children ].
	
	(children equals: nil ) ifFalse: [ 
		 children do: [ :each |
			res add: (self subTreeWithSymbol:children symbol:aSymbol). ]].
	
	^res.
]

{ #category : 'shrinking' }
UmeGrammarReducer >> symbolReduction: aTree for: aSymbol [

	| reduction uniqueReduction|
	reduction := OrderedCollection new.
	reduction add: (self subTreeWithSymbol: aTree symbol:aSymbol) ; add: (self alternateReductions: aTree symbol: aSymbol) . 
	uniqueReduction:= OrderedCollection new.
	(reduction ) do: [  :each |
		(each in: uniqueReduction ) ifFalse: (uniqueReduction add: each). 
	].
	^uniqueReduction. 
]

{ #category : 'shrinking' }
UmeGrammarReducer >> tree: input [

	^ self parse: input
]
