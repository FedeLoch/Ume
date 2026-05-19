Class {
	#name : 'UmeSimplifyGrammarSubtreeReducerTest',
	#superclass : 'UmeReductionShrinkerTest',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'tests' }
UmeSimplifyGrammarSubtreeReducerTest >> testMinimizingAnExpressionSubree [

	| expressionTree grammar res1|
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '1+(2*3)' from: grammar.
	res1:= (UmeSimplifyGrammarSubtreeReducer reduce: expressionTree).
	self assert:  res1 asInput equals: '(2*3)'. 
]
