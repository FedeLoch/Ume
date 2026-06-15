Class {
	#name : 'UmeShrinkingStrategy',
	#superclass : 'Object',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'copying' }
UmeShrinkingStrategy class >> copyTree: aTree with: aGrammar [

	^ UmeGrammarParser parse: (aTree asInput ) from: aGrammar
]

{ #category : 'enumerating' }
UmeShrinkingStrategy class >> reduce: subtree using: grammar matching: symbol [

	self subclassResponsibility 
]
