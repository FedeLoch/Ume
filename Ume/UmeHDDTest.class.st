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
UmeHDDTest >> testHDDReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+3' ) equals: '3'
]

{ #category : 'tests' }
UmeHDDTest >> testHDDReducer02 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $2 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(2)'
]

{ #category : 'tests' }
UmeHDDTest >> testHDDReducer03 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeHDDTest >> testHDDReducer04 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
UmeHDDTest >> testHDDReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeHDDTest >> testHDDReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [(string includes: $3)] ]).
	
	self assert:  ( shrinker shrink: '1+(2*3)' ) equals: '(23)'
]

{ #category : 'tests' }
UmeHDDTest >> testHDDReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $2) and: [(string includes: $1)] ]).
	
	self assert:  ( shrinker shrink: '1+(2*3)' ) equals: '1+(2)'
]

{ #category : 'tests' }
UmeHDDTest >> testHDDReducer08 [

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $3) and: [(string includes: $1)] ]).
	
	self assert:  ( shrinker shrink: '1+(2*3)' ) equals: '1+(3)'
]
