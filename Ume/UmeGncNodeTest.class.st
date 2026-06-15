Class {
	#name : 'UmeGncNodeTest',
	#superclass : 'TestCase',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'tests' }
UmeGncNodeTest >> testReplaceChildAt01 [

	| input treeInput grammar change treeChange replacementTree test |	
	input :=  '1+(2*3)'.
	change := '3'.
	
	grammar := AritExpressionGrammar new.
	
	treeInput := UmeGrammarParser parse: input from: grammar.
	treeChange := UmeGrammarParser parse: change from: grammar.
	
	test := OrderedCollection new.
	test add: treeChange .
	"result := treeInput replaceChildAt: 2 with: treeChange."
	replacementTree := treeInput at: 2.
	replacementTree children: test.
	
	self assert: (treeInput asInput) equals: '3'
]
