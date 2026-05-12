Class {
	#name : 'UmeGrammarBasedReducerTest',
	#superclass : 'TestCase',
	#instVars : [
		'shrinker'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'accessing' }
UmeGrammarBasedReducerTest >> setUp [
	
	shrinker := UmeGrammarReducer new.
	shrinker oracle: [ :input | (input includesSubstring: '4') ifTrue: [ Error ] ].
	shrinker grammar: JSONGrammar new.
	
]

{ #category : 'test' }
UmeGrammarBasedReducerTest >> testJSON [

	self assert: (shrinker shrink: '{"name": "Timo", "session": "2026", "score": 4, "completed": true}') equals: '4'
]

{ #category : 'test' }
UmeGrammarBasedReducerTest >> testJSON02 [

	self assert: (shrinker shrink: '[[[[1,2,4]]],{"a":null}]') equals: '4'
]

{ #category : 'test' }
UmeGrammarBasedReducerTest >> testJSON03 [

	self assert: (shrinker shrink: '[4]') equals: '4'
]
