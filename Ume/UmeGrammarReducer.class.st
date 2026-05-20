Class {
	#name : 'UmeGrammarReducer',
	#superclass : 'UmeShrinker',
	#instVars : [
		'grammar',
		'oracle',
		'reductionStrategy'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGrammarReducer >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGrammarReducer >> checkGrammar: aInput [

	^ UmeGrammarParser accept: aInput from: grammar
]

{ #category : 'copying' }
UmeGrammarReducer >> copyTree: tree [
 
	^ self tree: tree asInput
]

{ #category : 'shrinking' }
UmeGrammarReducer >> evalInput: input [

	^ ( oracle value: input )
]

{ #category : 'shrinking' }
UmeGrammarReducer >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'shrinking' }
UmeGrammarReducer >> minimizeOne: originalTree upperBound: bound [

	| canBeReduced currentTree reducedTree |
	
	currentTree := self copyTree: originalTree.  
	canBeReduced := false.
	
	reducedTree := UmeSimplifyGrammarSubtreeReducer reduce: (self copyTree: currentTree).
	reducedTree ifNotNil: [ 
		(self triggerBug: reducedTree upperBound: bound ) ifTrue: [ 
			currentTree := reducedTree.
			canBeReduced := true]].
	
	canBeReduced ifFalse: [ 
		reducedTree := UmeSimplifyGrammarAlternateReduction reduce: (self copyTree: currentTree).
		reducedTree ifNotNil: [ 
			(self triggerBug: reducedTree upperBound: bound ) ifTrue: [ 
				currentTree := reducedTree ]]].
    ^ currentTree
]

{ #category : 'shrinking' }
UmeGrammarReducer >> oracle [

	^ oracle
]

{ #category : 'shrinking' }
UmeGrammarReducer >> oracle: aOracle [

	oracle := aOracle
]

{ #category : 'shrinking' }
UmeGrammarReducer >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'accessing' }
UmeGrammarReducer >> reductionStrategy [

	^ reductionStrategy
]

{ #category : 'accessing' }
UmeGrammarReducer >> reductionStrategy: aStrategy [

	reductionStrategy := aStrategy
]

{ #category : 'shrinking' }
UmeGrammarReducer >> tree: input [

	^ self parse: input
]

{ #category : 'testing' }
UmeGrammarReducer >> triggerBug: aTree upperBound: _ [

	|input|
	
	input := (self asInput: aTree).
	(self checkGrammar: input ) ifFalse: [ ^false ].

	^ (self evalInput: input ) not
]
