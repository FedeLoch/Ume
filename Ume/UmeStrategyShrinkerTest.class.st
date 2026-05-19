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
UmeStrategyShrinkerTest >> testUsingTheAlternateExpansionStrategy [ 
	
	shrinker oracle: [ :string | (string includes: $2) not].
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheAlternateExpansionStrategy02 [
	
	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheAlternateExpansionStrategy03 [
	
	shrinker oracle: [ :string | (string includes: $1) not].
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheSubtreeStrategy [ 

	shrinker oracle: [ :string | (string includes: $2) not].
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(2)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheSubtreeStrategy02 [

	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheSubtreeStrategy03 [

	shrinker oracle: [ :string | (string includes: $1) not].
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheTagReducingStrategy [ 

	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarTagReducer.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]
