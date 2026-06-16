Class {
	#name : 'UmeHDDTest',
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
UmeHDDTest >> setUp [

	super setUp.
	shrinker := UmeHDDShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
UmeHDDTest >> testGrammarReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+5*(2*3)' ) equals: '3'
]

{ #category : 'tests' }
UmeHDDTest >> testGrammarReducer02 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+3' ) equals: '3'
]
