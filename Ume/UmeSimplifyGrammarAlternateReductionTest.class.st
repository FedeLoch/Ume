Class {
	#name : 'UmeSimplifyGrammarAlternateReductionTest',
	#superclass : 'UmeReductionShrinkerTest',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'tests' }
UmeSimplifyGrammarAlternateReductionTest >> testMinimizingATreeWithAAlternativeExpansion [

	| expressionTree grammar res stringList expectedRes|
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '1+(2+(3*4))' from: grammar.
	res := (UmeSimplifyGrammarAlternateReduction alternateReduction: expressionTree  using: grammar matchingWith: 'Expr' ).
	stringList := res collect: #asInput.
	expectedRes := #('1' '2' ).
	1 halt.
	self assert: (stringList includesAll: expectedRes).
]

{ #category : 'tests' }
UmeSimplifyGrammarAlternateReductionTest >> testMinimizingATreeWithAAlternativeExpansion1 [

	| expressionTree grammar res stringList expectedRes|
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '1+2' from: grammar.
	res := (UmeSimplifyGrammarAlternateReduction alternateReduction: expressionTree  using: grammar matchingWith: 'Expr' ).
	stringList := res collect: #asInput. "2, 1, 2+2, 1+2"
	expectedRes := #( '2' '1' '2+2' ).
	self assert: (stringList includesAll: expectedRes).
]

{ #category : 'tests' }
UmeSimplifyGrammarAlternateReductionTest >> testMinimizingATreeWithAAlternativeExpansion3 [

	| expressionTree grammar res stringList expectedRes |
	grammar := AritExpressionGrammar new.

	expressionTree := UmeGrammarParser parse: '1+(2*3)' from: grammar.
	res := (UmeSimplifyGrammarAlternateReduction alternateReduction: expressionTree  using: grammar matchingWith: 'Term' ).
	stringList := res collect: #asInput.
	expectedRes := #( '2' '1' '3' '(2*3)').
	self assert: (stringList includesAll: expectedRes).
]
