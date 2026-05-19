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
UmeGrammarReducer >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGrammarReducer >> checkGrammar: aInput [

	^ UmeGrammarParser accept: aInput from: grammar
]

{ #category : 'shrinking' }
UmeGrammarReducer >> evalInput: input [

	(self checkGrammar: input ) ifFalse: [ ^false ].
	^ [ oracle value: input. false] on: Error do: [ :e | true ]
]

{ #category : 'shrinking' }
UmeGrammarReducer >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'shrinking' }
UmeGrammarReducer >> minimizeOne: tree upperBound: bound [

	^ UmeSimplifyGrammarSubtreeReducer reduce: tree
]

{ #category : 'shrinking' }
UmeGrammarReducer >> oracle: aOracle [

	oracle := aOracle
]

{ #category : 'shrinking' }
UmeGrammarReducer >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'shrinking' }
UmeGrammarReducer >> tree: input [

	^ self parse: input
]

{ #category : 'testing' }
UmeGrammarReducer >> triggerBug: aTree upperBound: bound [

	|input|
	input := (self asInput: aTree).
	^ (self evalInput: input) = bound
]
