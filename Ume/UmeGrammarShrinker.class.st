Class {
	#name : 'UmeGrammarShrinker',
	#superclass : 'UmeShrinker',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'testing' }
UmeGrammarShrinker >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'shrinking' }
UmeGrammarShrinker >> tree: input [

	^ self parse: input
]
