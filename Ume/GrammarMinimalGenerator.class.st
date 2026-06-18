Class {
	#name : 'GrammarMinimalGenerator',
	#superclass : 'GncVisitor',
	#instVars : [
		'grammar',
		'randomGenerator'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'accessing' }
GrammarMinimalGenerator >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'initialization' }
GrammarMinimalGenerator >> initialize [

	super initialize.
	randomGenerator := GncPCGRandomGenerator new
]

{ #category : 'initialization' }
GrammarMinimalGenerator >> random [

	^ randomGenerator
]

{ #category : 'visiting' }
GrammarMinimalGenerator >> selectRule: rules [

	^ (rules sorted: [ :a :b | a minSize < b minSize ]) first
]

{ #category : 'visiting' }
GrammarMinimalGenerator >> visitNonTerminal: nonTerminal [

	| rule |
	
	rule := self selectRule: nonTerminal rules.
	
	^ (rule visit: self) tag: nonTerminal name
]

{ #category : 'visiting' }
GrammarMinimalGenerator >> visitRule: rule [
	
	^ GncInnerNode with: (rule fragments collect: [ :fragment | (fragment visit: self) grammarRule: rule; yourself ])
]

{ #category : 'visiting' }
GrammarMinimalGenerator >> visitTerminal: terminal [

	^ terminal generateAst: self
]
