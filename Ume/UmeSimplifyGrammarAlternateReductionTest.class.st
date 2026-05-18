Class {
	#name : 'UmeSimplifyGrammarAlternateReductionTest',
	#superclass : 'TestCase',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'tests' }
UmeSimplifyGrammarAlternateReductionTest >> testMinimizingATreeWithAAlternativeExpansion [

	| expressionTree grammar res1|
	
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '2*3' from: grammar.
	res1:= (UmeSimplifyGrammarAleternateReduction reduce: expressionTree).
	self assert:  res1 asInput equals: '3'. 
]
