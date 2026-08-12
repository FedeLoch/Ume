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
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer00 [ 

	shrinker mainReducer: UmeHDDShrinker new.  
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).
		
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]
