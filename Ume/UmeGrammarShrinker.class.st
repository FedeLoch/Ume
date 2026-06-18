Class {
	#name : 'UmeGrammarShrinker',
	#superclass : 'UmeShrinker',
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
UmeGrammarShrinker >> isValidTree: tree [

	| input derivation |
	input := tree asInput.

	[ derivation := self parse: input ] on: Error do: [ ^ false ].
	derivation ifNil: [ ^ false ].

	^ derivation asInput = input
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
