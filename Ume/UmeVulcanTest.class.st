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
	shrinker grammar: grammar.
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer00 [ 
 
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar. 
	
	shrinker mainReducer: UmeHDDShrinker new.
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).
		
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer02 [

	| oracle res |
	oracle := (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).
	
	shrinker grammar: SvgPathGrammar new.
	
	shrinker mainReducer: UmeHDDShrinker new. 
	shrinker oracle: oracle.
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  res equals: 'm2-5'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer03 [

	| oracle input |
	oracle := PerformanceOracle new threshold: 0.9; evalBlock: [ :path | SVGRunner run: path ].
	
	shrinker grammar: SvgPathGrammar new.
	
	shrinker mainReducer: UmeHDDShrinker new. 
	shrinker oracle: oracle.
	input := 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.

	self assert:  (shrinker shrink: input) size < (input size)
]
