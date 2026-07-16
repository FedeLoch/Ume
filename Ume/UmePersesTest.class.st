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
