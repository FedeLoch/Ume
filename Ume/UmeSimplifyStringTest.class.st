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
	shrinker oracle: [ :string | (string includes: $e) not].

]

{ #category : 'running' }
UmeSimplifyStringTest >> testSplit [ 

	| string string2 res res2|
	string := 'abcde'.
	string2:= 'ab'.
	
	res := OrderedCollection new.
	res add: 'abc'; add:'de'.
	res2 := OrderedCollection  new.
	res2 add: 'a'; add: 'b'.
	
	self assert: (shrinker split: string into:2) equals: res.
	self assert: (shrinker split: string2 into: 2) equals: res2. 
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
	
	shrinker splittingValue: 3.
	self assert: (shrinker shrink: 'eqlbfkdjbkj') equals: 'eq'
]

{ #category : 'running' }
UmeSimplifyStringTest >> testString06 [
	
	shrinker splittingValue: 20.
	self assert: (shrinker shrink: 'gjnjconjcome') equals: 'gjnjconjcome'
]
