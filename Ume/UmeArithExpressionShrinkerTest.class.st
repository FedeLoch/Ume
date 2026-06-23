Class {
	#name : 'UmeArithExpressionShrinkerTest',
	#superclass : 'UmeGrammarBasedShrinkerTest',
	#instVars : [
		'shrinker'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'running' }
UmeArithExpressionShrinkerTest >> setUp [ 
	
	super setUp.
	self timeLimit: 5 hours.
	shrinker := UmeNautilusShrinker new.
	shrinker grammar: AritExpressionGrammar new.
]

{ #category : 'running' }
UmeArithExpressionShrinkerTest >> testMinimizeSimpleExpression [

	| node |
	
	node := self tree: '(2+2)/0'.
	
	"'(2+2)/0' -> '1/0'"
	self assert: (shrinker minimized: node) asInput size equals: 1
]

{ #category : 'running' }
UmeArithExpressionShrinkerTest >> testMinimizeSimpleExpression1 [

	| node |
	
	node := self tree: '1+(2*3)'.

	self assert: (shrinker minimized: node) asInput size equals: 1
]

{ #category : 'running' }
UmeArithExpressionShrinkerTest >> tree: input [

	^ UmeGrammarParser parse: input from: shrinker grammar
]
