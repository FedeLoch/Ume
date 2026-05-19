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
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(2*3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheAlternateExpansionStrategy02 [
	
	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheSubtreeStrategy [ 

	shrinker oracle: [ :string | (string includes: $2) not].
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(2*3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testUsingTheSubtreeStrategy02 [

	shrinker oracle: [ :string | (string includes: $3) not].
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]
