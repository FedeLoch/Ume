Class {
	#name : 'UmeVulcanTest',
	#superclass : 'UmeReductionShrinkerTest',
	#instVars : [
		'shrinker',
		'grammar'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'running' }
UmeVulcanTest >> setUp [

	super setUp.
	shrinker := UmeVulcanShrinker new.
	self timeLimit: 2 minutes.
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer00 [ 
 
	shrinker grammar: AritExpressionGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
		
	self assert:  (shrinker shrink: '1+(3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer01 [ 
 
	shrinker grammar: AritExpressionGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '3' ]).
		
	self assert:  (shrinker shrink: '1+2*(2+3)' ) equals: '3'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer02 [

	| res |
	
	shrinker grammar: SvgPathGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  res equals: 'm2-5'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer03 [

	| oracle input res |
	oracle := PerformanceOracle new threshold: 0.9; evalBlock: [ :path | SVGRunner run: path ].
	
	shrinker grammar: SvgPathGrammar new.
	
	shrinker mainReducer: UmeHDDShrinker new. 
	shrinker oracle: oracle.
	input := 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	shrinker limit: 1. 
	
	res := shrinker shrink: input.

	self assert:  res size < (input size)
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer04 [
 
	shrinker grammar: AritExpressionGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '2' ]).
		
	self assert:  (shrinker shrink: '1+2*(2+3)' ) equals: '2'
]
