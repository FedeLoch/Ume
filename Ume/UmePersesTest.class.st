Class {
	#name : 'UmePersesTest',
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
UmePersesTest >> setUp [

	super setUp.
	shrinker := UmePersesShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
UmePersesTest >> testPersesReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+3' ) equals: '3'
]

{ #category : 'tests' }
UmePersesTest >> testPersesReducer02 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '(3)'
]
