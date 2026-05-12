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
UmeGrammarReducer >> getSymbol: aNode [
	
	| fragments res|
	
	res := OrderedCollection new. 
	fragments :=  aNode grammarRule fragments.
	fragments do: [ :fragment | res add: fragment rules ].
	^res.
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
		symbol := self getSymbol: node. 
		1 halt.
		parent ifNotNil: [ 
			1 halt.
			index := parent children indexOf: node.
			(self symbolReduction: node for: symbol ) do: [ :reduction |
				1 halt.
				(reduction allNodes size < node allNodes size) ifTrue:[
					parent replaceChildAt: index with: reduction.
					1 halt.
					(self triggerBug: tree upperBound: bound ) 
					ifTrue: [ ^tree.] 
					ifFalse: [ parent replaceChildAt: index with: node.].
					1 halt.
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
		(aSymbol includes: node ) ifTrue: [ res add: node ] ].
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
	^ (self evalInput: input) = bound.
]
