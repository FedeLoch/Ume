Class {
	#name : 'UmeSimpleStringTest',
	#superclass : 'UmeReductionShrinkerTest',
	#instVars : [
		'shrinker'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'running' }
UmeSimpleStringTest >> setUp [
	super setUp.
	shrinker := UmeReductionShrinker new.
	
	shrinker oracle: [ :string | (string includes: $e) not].

]

{ #category : 'running' }
UmeSimpleStringTest >> testSplit [ 

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
UmeSimpleStringTest >> testString [ 
	
	self assert: (shrinker shrink: 'asqjjkqsbdvieqvsbdoivbq') equals: 'e'
]

{ #category : 'running' }
UmeSimpleStringTest >> testString02 [

	self assert: (shrinker shrink: 'e') equals: 'e'
]

{ #category : 'running' }
UmeSimpleStringTest >> testString03 [

	self assert: (shrinker shrink: 'eq') equals: 'e'
]

{ #category : 'running' }
UmeSimpleStringTest >> testString04 [
	
	self assert: (shrinker shrink: 'eeeeeeeeeeeeeeeeeeeeeeeeee') equals: 'e'
]

{ #category : 'running' }
UmeSimpleStringTest >> testString05 [
	
	self assert: (shrinker shrink: 'eqlbfkdjbkj') equals: 'e'
]

{ #category : 'running' }
UmeSimpleStringTest >> testString06 [
	
	self assert: (shrinker shrink: 'gjnjconjcome') equals: 'e'
]
