Class {
	#name : 'UmeStrategyShrinkerTest',
	#superclass : 'UmeReductionShrinkerTest',
	#instVars : [
		'shrinker',
		'grammar'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'accessing' }
UmeStrategyShrinkerTest >> setUp [

	super setUp.
	shrinker := UmeGrammarReducer new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer00 [ 

	shrinker oracle: [ :string | (string includes: $2) not].
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(2)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer01 [

	shrinker oracle: [ :string | (string includes: $1) not].
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer02 [

	shrinker oracle: [ :string | (string includes: $3) not].
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]
