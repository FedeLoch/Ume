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
	shrinker := UmeGRABRShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer00 [ 

	shrinker oracle: [ :string | (string includes: $2) not].
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer . 
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer01 [

	shrinker oracle: [ :string | (string includes: $1) not].
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer02 [

	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer03 [

	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarBoth. 
	self assert:  (shrinker shrink: '2*3' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer04 [

	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3*2' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer05 [

	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3' ) equals: '3'
]
