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
