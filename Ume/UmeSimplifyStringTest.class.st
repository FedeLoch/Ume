Class {
	#name : 'UmeSimplifyStringTest',
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
UmeSimplifyStringTest >> setUp [

	super setUp.
	shrinker := UmeDeltaDebugger new.	
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $e) ]).

]

{ #category : 'running' }
UmeSimplifyStringTest >> testString [ 
	
	self assert: (shrinker shrink: 'asqjjkqsbdvieqvsbdoivbq') equals: 'e'
]

{ #category : 'running' }
UmeSimplifyStringTest >> testString02 [

	self assert: (shrinker shrink: 'e') equals: 'e'
]

{ #category : 'running' }
UmeSimplifyStringTest >> testString03 [

	self assert: (shrinker shrink: 'eq') equals: 'e'
]

{ #category : 'running' }
UmeSimplifyStringTest >> testString04 [
	
	self assert: (shrinker shrink: 'eeeeeeeeeeeeeeeeeeeeeeeeee') equals: 'e'
]

{ #category : 'running' }
UmeSimplifyStringTest >> testString05 [

	shrinker oracle: (self oracleByBlock: [ :string |
			 (string includes: $e) and: (string includes: $a) ]).

	self
		assert: (shrinker shrink: 'kjdsfhkjqsdhfehdkjsqfhkjsa')
		equals: 'ea'
]

{ #category : 'running' }
UmeSimplifyStringTest >> testString06 [
	
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '3'
]
