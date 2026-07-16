Class {
	#name : 'UmeStrategyShrinkerTest',
	#superclass : 'UmeReductionShrinkerTest',
	#instVars : [
		'shrinker',
		'grammar'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'accessing' }
UmeStrategyShrinkerTest >> setUp [

	super setUp.
	shrinker := UmeGRABRShrinker new.
	grammar := AritExpressionGrammar new.
	shrinker grammar: grammar.
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer00 [ 

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(3)' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction . 
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer01 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $1 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '1'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer02 [
	
	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(3)' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer03 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '2*3' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer04 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3*2' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer05 [

	shrinker oracle: (self oracleByBlock: [ :string | string includes: $3 ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	
	self assert:  (shrinker shrink: '3' ) equals: '3'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer06 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '(' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer . 
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer07 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '4' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer . 
	
	self assert:  (shrinker shrink: '1+(3)' ) equals: '1+(3)'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer08 [

	shrinker oracle: (self oracleByBlock: [ :string | string includesSubstring: '2' ]).
	shrinker reductionStrategy: UmeSimplifyGrammarAlternateReduction . 

	self assert:  (shrinker shrink: '1+(2*3)' ) equals: '2'
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer09 [

	| res |

	shrinker oracle: (self oracleByBlock: [ :string | (string includes: $3) and: (string includes: $1) ]).
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	res:= shrinker shrink: '3*2+(4*1)'.
	
	self assert:  ((res = '3*1') or: (res = '3+1'))
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer10 [

	| grammar2 oracle input |
	grammar2 := GncRegexGrammar new.
	oracle := PerformanceOracle new threshold: 0.9; evalBlock: [ :regex |
		regex asRegex matches: regex minimalStringMatching
	].

	shrinker oracle: oracle.
	shrinker grammar: grammar2.
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	input := 'b.*(acca+a*..(.)c|.*|||)(b+|b?|cb*b*)c+'.
	
	self assert:  (shrinker shrink: input) size < input size 
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer11 [

	| oracle input |
	oracle := PerformanceOracle new threshold: 0.9; evalBlock: [ :path | SVGRunner run: path ].

	shrinker oracle: oracle.
	shrinker grammar: SvgPathGrammar new.
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	input := 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  (shrinker shrink: input) size < (input size)
]

{ #category : 'tests' }
UmeStrategyShrinkerTest >> testGrammarReducer12 [

	| oracle res |
	oracle := (self oracleByBlock: [ :string | (string includes: $5) and: (string includes: $2) ]).

	shrinker oracle: oracle.
	shrinker grammar: SvgPathGrammar new.
	shrinker reductionStrategy: UmeSimplifyGrammarBoth.
	res := shrinker shrink: 'm-.99,-.4,7-93.,03-.8 -19.9-.2449 -1742 -269 -747 -5 16.-132 21.04-55.9'.
	
	self assert:  res equals: 'm2-5'
]
