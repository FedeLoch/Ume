Class {
	#name : 'UmeVulcanTest',
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
UmeVulcanTest >> setUp [

	super setUp.
	shrinker := UmeVulcanShrinker new.
	self timeLimit: 2 minutes.
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer00 [ 
 
	shrinker grammar: AritExpressionGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
		
	self assert:  (shrinker shrink: '1+(3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer01 [ 
 
	shrinker grammar: AritExpressionGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '3' ]).
		
	self assert:  (shrinker shrink: '1+2*(2+3)' ) equals: '3'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer02 [

	| res |
	
	shrinker grammar: SvgPathGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  res equals: 'm2-5'
]

{ #category : 'tests' }
UmeVulcanTest >> testGrammarReducer03 [

	| input res |
	
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $a ]).
	shrinker grammar: GncRegexGrammar new.
	shrinker mainReducer: UmeHDDShrinker new. 
	input := '((((a))))'.
	shrinker setWindowSize: 3.
	
	res := shrinker shrink: input.

	self assert:  res size < (input size)
]

{ #category : 'tests' }
UmeVulcanTest >> testIdentifierReplacement04 [

	| input bound tree | 

	shrinker grammar: AritExpressionGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '2' ]).
	input := '1+2'.
	tree := shrinker tree: input.
	bound := shrinker evalInput: input.

	self assert:  (shrinker identifierReplacer reduce: tree bound: bound ) asInput equals: '2+2'
]

{ #category : 'tests' }
UmeVulcanTest >> testIdentifierReplacement05 [

	| input bound tree | 

	shrinker grammar: AritExpressionGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $+) and: (string includes: $2) ]).
	input := '1+2*3'.
	tree := shrinker tree: input.
	bound := shrinker evalInput: input.

	self assert:  (shrinker identifierReplacer reduce: tree bound: bound) asInput equals: '2+2+2'
]

{ #category : 'tests' }
UmeVulcanTest >> testIdentifierReplacement06 [

	| input bound tree | 

	shrinker grammar: SvgPathGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $5 ]).
	input := 'm-.59,-.4,7-93.,03-.8'.
	tree := shrinker tree: input.
	bound := shrinker evalInput: input.

	self assert:  (shrinker identifierReplacer reduce: tree bound: bound) asInput equals: 'm-.55,-.5,5-55.,55-.5'
]

{ #category : 'tests' }
UmeVulcanTest >> testTreeBasedLEE07 [

	| input bound tree | 

	shrinker grammar: SvgPathGrammar new.
	shrinker oracle: (self oracleByBlock: [ :string | string includes: $5 ]).
	input := 'm-.59,-.4,7-93.,03-.8'.
	tree := shrinker tree: input.
	bound := shrinker evalInput: input.

	self assert:  (shrinker treeBasedLee reduce: tree bound: bound) asInput equals: 'm59,4'
]
