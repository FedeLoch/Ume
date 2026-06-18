Class {
	#name : 'UmeGrammarShrinker',
	#superclass : 'UmeShrinker',
	#instVars : [
		'minimalGenerator'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGrammarShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGrammarShrinker >> checkGrammar: aInput [

	^ UmeGrammarParser accept: aInput from: grammar
]

{ #category : 'testing' }
UmeGrammarShrinker >> grammar: aGrammar [

	super grammar: aGrammar.
	minimalGenerator grammar: aGrammar
]

{ #category : 'testing' }
UmeGrammarShrinker >> initialize [ 
	
	super initialize.
	minimalGenerator := GrammarMinimalGenerator new.
]

{ #category : 'testing' }
UmeGrammarShrinker >> isValidTree: tree [

	| input derivation |
	input := tree asInput.

	[ derivation := self parse: input ] on: Error do: [ ^ false ].
	derivation ifNil: [ ^ false ].

	^ derivation asInput = input
]

{ #category : 'shrinking' }
UmeGrammarShrinker >> minimized: node [

	| newNode |
	
	newNode := node grammarRule visit: minimalGenerator.
	newNode tag: node	tag.
	newNode grammarRule: node grammarRule.

	^ newNode
]

{ #category : 'testing' }
UmeGrammarShrinker >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'shrinking' }
UmeGrammarShrinker >> tree: input [

	^ self parse: input
]

{ #category : 'testing' }
UmeGrammarShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).
	(self checkGrammar: input) ifFalse: [ ^ false ].

	^ oracle accepts: input from: originalScore
]
