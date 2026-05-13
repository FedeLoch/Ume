Class {
	#name : 'UmeSimplifyGrammarSubtreeReducerTest',
	#superclass : 'TestCase',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'tests' }
UmeSimplifyGrammarSubtreeReducerTest >> testMinimizingAnExpressionSubree [

	| expressionTree expected grammar |
	grammar := nil.
	expressionTree := UmeGrammarParser parse: '1 + ( 2 * 3 )' from: grammar.
	expected := UmeGrammarParser parse: '( 2 * 3 )' from: grammar.
	self assert: (UmeSimplifyGrammarSubtreeReducer reduce: expressionTree) equals: expected 
]
