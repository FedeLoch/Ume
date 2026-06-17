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

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(3)' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction . 
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer02 [
	
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(3)' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer03 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '2*3' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer04 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3*2' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer . 
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '4' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer . 
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '1+(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer08 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '2' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction . 

	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]
