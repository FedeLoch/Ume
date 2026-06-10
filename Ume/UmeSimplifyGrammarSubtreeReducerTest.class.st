Class {
	#name : 'UmeSimplifyGrammarSubtreeReducerTest',
	#superclass : 'UmeReductionShrinkerTest',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'tests' }
UmeSimplifyGrammarSubtreeReducerTest >> testMinimizingAnExpressionSubree [

	| expressionTree grammar res stringList expectedRes|
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '1+(2*3)' from: grammar.
	res := (UmeSimplifyGrammarSubtreeReducer findSubtree: expressionTree mathchingWith: 'Term' ).
	stringList := res collect: #asInput.
	expectedRes := #('(2*3)' '1' '2' '3').
	
	self assert: (stringList includesAll: expectedRes).
]
