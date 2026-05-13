Class {
	#name : 'AritExpressionGrammar',
	#superclass : 'GncGrammar',
	#instVars : [
		'ntStart',
		'ntExpr',
		'ntTerm',
		'ntOp',
		'ntFactor',
		'ntInt',
		'ntDigit'
	],
	#category : 'Ume-Grammars',
	#package : 'Ume',
	#tag : 'Grammars'
}

{ #category : 'initialization' }
AritExpressionGrammar >> defineGrammar [

	ntStart --> ntExpr.
	
	ntExpr --> ntTerm | ntTerm, ntOp, ntExpr.
	
	ntTerm --> ntFactor.
	
	ntFactor --> ntInt | '(', ntExpr, ')'.
	
	ntInt --> ntDigit.
	
	ntDigit --> ($0 - $9).
	
	ntOp --> '+' | '*'.
	
	^ ntStart 
]
