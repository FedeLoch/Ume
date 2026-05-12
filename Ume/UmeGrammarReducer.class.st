Class {
	#name : 'UmeGrammarReducer',
	#superclass : 'UmeShrinker',
	#instVars : [
		'grammar',
		'oracle'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGrammarReducer >> alternateReductions: aTree symbol: aSymbol [

	| reduction |
	reduction := OrderedCollection new. 
	aTree children do: [ :child |
		reduction addAll: (self subtreeWithSymbol: child symbol: aSymbol ) ].
	^reduction .
]

{ #category : 'shrinking' }
UmeGrammarReducer >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGrammarReducer >> checkGrammar: aInput [

	^UmeGrammarParser accept: aInput from: grammar. 
]

{ #category : 'shrinking' }
UmeGrammarReducer >> evalInput: input [

	(self checkGrammar: input ) ifFalse: [ ^false ].
	^[ oracle value: input. false] on: Error do: [ :e | true ].
]

{ #category : 'shrinking' }
UmeGrammarReducer >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'shrinking' }
UmeGrammarReducer >> minimizeOne: tree upperBound: bound [

	| allNodes |
	allNodes := tree allNodes.
	allNodes  do: [ :node | |parent symbol index|
		parent := node parent. 
		symbol := node grammarRule . 
		parent ifNotNil: [ 
			index := parent children indexOf: node.
			(self alternateReductions: node symbol: symbol ) do: [ :reduction |
				(reduction allNodes size < node allNodes size) ifTrue:[
					parent replaceChildAt: index with: reduction.
					(self triggerBug: tree upperBound: bound ) "should also check grammar"
					ifTrue: [ ^tree.] 
					ifFalse: [ parent replaceChildAt: index with: node.].
				].
			].
		].
	].
	^ tree.
]

{ #category : 'shrinking' }
UmeGrammarReducer >> oracle: aMethod [

	oracle := aMethod. 
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
UmeGrammarReducer >> subtreeWithSymbol: aTree symbol: aSymbol [

	| res |
	
	res := OrderedCollection new.
	aTree allNodes do: [ :node |
		(node grammarRule = aSymbol ) ifTrue: [ res add: node ] ].
	^res.
]

{ #category : 'shrinking' }
UmeGrammarReducer >> symbolReduction: aTree for: aSymbol [

	| reduction |
	reduction := Set new.
	reduction addAll: (self subtreeWithSymbol: aTree symbol: aSymbol ).
	reduction addAll: (self alternateReductions: aTree symbol: aSymbol ).
	^reduction asOrderedCollection.
]

{ #category : 'shrinking' }
UmeGrammarReducer >> tree: input [

	^ self parse: input
]

{ #category : 'testing' }
UmeGrammarReducer >> triggerBug: aTree upperBound: bound [

	|input|
	input := (self asInput: aTree).
	1 halt.
	^ (self evalInput: input) = bound.
]
