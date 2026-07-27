Class {
	#name : 'UmePNFConverterTest',
	#superclass : 'TestCase',
	#category : 'Ume Tests-PNF',
	#package : 'Ume Tests',
	#tag : 'PNF'
}

{ #category : 'tests' }
UmePNFConverterTest >> testConvertLiteralGrammar [

	| grammar pnf |
	grammar := GncLiteralGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: pnf start name equals: 'Literal'.
	self assert: (pnf minHeight isFinite).
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertRangeGrammar [

	| grammar pnf |
	grammar := GncRangeGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite).
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertDisjunctionGrammar [

	| grammar pnf |
	grammar := GncDisjunctionGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite).
	self assert: pnf nonTerminals isNotEmpty
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertConcatGrammar [

	| grammar pnf |
	grammar := GncConcatGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite)
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertBaseGrammar [

	| grammar pnf |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite).
	self assert: pnf nonTerminals isNotEmpty
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertExpressionGrammar [

	| grammar pnf |
	grammar := GncExpressionGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite).
	self assert: pnf nonTerminals isNotEmpty
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertAssociationsGrammar [

	| grammar pnf |
	grammar := AssociationsGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite)
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertJSONGrammar [

	| grammar pnf |
	grammar := JSONGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite).
	self assert: pnf nonTerminals isNotEmpty
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertMarkdownGrammar [

	| grammar pnf |
	grammar := MarkdownGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite)
]

{ #category : 'tests' }
UmePNFConverterTest >> testConvertAritExpressionGrammar [

	| grammar pnf |
	grammar := AritExpressionGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf start notNil.
	self assert: (pnf minHeight isFinite).
	self assert: pnf nonTerminals isNotEmpty
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testAllRulesStartWithTerminal [

	| grammar pnf |
	grammar := GncExpressionGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			rule fragments ifNotEmpty: [
				| first |
				first := rule fragments first.
				self assert: (first isKindOf: GncTerminal)
					description: 'Rule of ', nt name, ' does not start with terminal: ', first printString ] ] ]
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testNoLeftRecursion [

	| grammar pnf |
	grammar := GncExpressionGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			rule fragments ifNotEmpty: [
				| first |
				first := rule fragments first.
				(first isKindOf: GncNonTerminal) ifTrue: [
					self assert: first name ~= nt name
						description: 'Left recursion found in ', nt name ] ] ] ]
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testNoEpsilonProductions [

	| grammar pnf |
	grammar := GncExpressionGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			self deny: rule fragments isEmpty
				description: 'Epsilon production found in ', nt name ] ]
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testNoUnitProductions [

	| grammar pnf |
	grammar := GncExpressionGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			(rule fragments size = 1 and: [
				rule fragments first isKindOf: GncNonTerminal ]) ifTrue: [
				self fail: 'Unit production found in ', nt name ] ] ]
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testNoUnitProductionsJSON [

	| grammar pnf |
	grammar := JSONGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			(rule fragments size = 1 and: [
				rule fragments first isKindOf: GncNonTerminal ]) ifTrue: [
				self fail: 'Unit production found in ', nt name ] ] ]
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testAllRulesInGNFArit [

	| grammar pnf |
	grammar := AritExpressionGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			rule fragments ifNotEmpty: [
				self assert: (rule fragments first isKindOf: GncTerminal)
					description: 'Rule in ', nt name, ' does not start with terminal'.
				(2 to: rule fragments size) do: [ :i |
					self assert: ((rule fragments at: i) isKindOf: GncNonTerminal)
						description: 'Non-NT symbol in tail of ', nt name, ' rule' ] ] ] ]
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testBuildGrammarCreatesValidStructure [

	| grammar pnf |
	grammar := GncConcatGrammar new.
	pnf := grammar to_pnf.
	self assert: (pnf isKindOf: UmePNFGrammar).
	self assert: pnf start notNil.
	self assert: (pnf start isKindOf: GncNonTerminal).
	self assert: pnf nonTerminals isNotEmpty.
	self assert: (pnf nonTerminals allSatisfy: [ :nt |
		(nt isKindOf: GncNonTerminal) and: [ nt rules isNotEmpty ] ])
]

{ #category : 'generator tests' }
UmePNFConverterTest >> testPNFGrammarCanGenerate [

	| grammar pnf generator |
	grammar := GncConcatGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	self assert: (generator generate isKindOf: String).
	self assert: generator generate isNotEmpty
]

{ #category : 'generator tests' }
UmePNFConverterTest >> testPNFGrammarCanGenerateDisjunction [

	| grammar pnf generator string |
	grammar := GncDisjunctionGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	string := generator generate.
	self assert: (string = 'oui' or: [ string = 'non' ])
]

{ #category : 'generator tests' }
UmePNFConverterTest >> testPNFGrammarCanGenerateBase [

	| grammar pnf generator |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	self assert: (generator generate isKindOf: String).
	self assert: generator generate isNotEmpty
]

{ #category : 'generator tests' }
UmePNFConverterTest >> testPNFGrammarCanGenerateExpression [

	| grammar pnf generator |
	grammar := GncExpressionGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	self assert: (generator generate isKindOf: String).
	self assert: generator generate isNotEmpty
]

{ #category : 'parser tests' }
UmePNFConverterTest >> testParseWithOriginalGrammar [

	| originalGrammar pnfGrammar generator string |
	originalGrammar := GncConcatGrammar new.
	pnfGrammar := originalGrammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnfGrammar; maxHeight: 100; maxSize: 100.
	string := generator generate.
	self assert: (UmeGrammarParser accept: string from: originalGrammar)
		description: 'Generated string from PNF grammar could not be parsed by original grammar: ', string
]

{ #category : 'parser tests' }
UmePNFConverterTest >> testParseWithOriginalGrammarDisjunction [

	| originalGrammar pnfGrammar generator string |
	originalGrammar := GncDisjunctionGrammar new.
	pnfGrammar := originalGrammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnfGrammar; maxHeight: 100; maxSize: 100.
	string := generator generate.
	self assert: (UmeGrammarParser accept: string from: originalGrammar)
		description: 'Generated string from PNF grammar could not be parsed by original grammar: ', string
]

{ #category : 'parser tests' }
UmePNFConverterTest >> testParseWithOriginalGrammarBase [

	| originalGrammar pnfGrammar generator string |
	originalGrammar := GncBaseGrammar new.
	pnfGrammar := originalGrammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnfGrammar; maxHeight: 100; maxSize: 100.
	string := generator generate.
	self assert: (UmeGrammarParser accept: string from: originalGrammar)
		description: 'Generated string from PNF grammar could not be parsed by original grammar: ', string
]

{ #category : 'parser tests' }
UmePNFConverterTest >> testParseWithOriginalGrammarExpression [

	| originalGrammar pnfGrammar generator string |
	originalGrammar := GncExpressionGrammar new.
	pnfGrammar := originalGrammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnfGrammar; maxHeight: 100; maxSize: 100.
	string := generator generate.
	self assert: (UmeGrammarParser accept: string from: originalGrammar)
		description: 'Generated string from PNF grammar could not be parsed by original grammar: ', string
]

{ #category : 'parser tests' }
UmePNFConverterTest >> testMultipleGenerationsParseBack [

	| originalGrammar pnfGrammar generator |
	originalGrammar := GncExpressionGrammar new.
	pnfGrammar := originalGrammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnfGrammar; maxHeight: 100; maxSize: 100.
	10 timesRepeat: [
		| string |
		string := generator generate.
		self assert: (UmeGrammarParser accept: string from: originalGrammar)
			description: 'Failed to parse: ', string ]
]

{ #category : 'parser tests' }
UmePNFConverterTest >> testMultipleGenerationsParseBackJSON [

	| originalGrammar pnfGrammar generator |
	originalGrammar := JSONGrammar new.
	pnfGrammar := originalGrammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnfGrammar; maxHeight: 100; maxSize: 50.
	5 timesRepeat: [
		| string |
		string := generator generate.
		self assert: (UmeGrammarParser accept: string from: originalGrammar)
			description: 'Failed to parse: ', string ]
]

{ #category : 'accessor tests' }
UmePNFConverterTest >> testPNFGrammarMinHeight [

	| grammar pnf |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	self assert: (pnf minHeight isFinite).
	self assert: pnf minHeight >= 0
]

{ #category : 'accessor tests' }
UmePNFConverterTest >> testPNFGrammarMinSize [

	| grammar pnf |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	self assert: (pnf minSize isFinite).
	self assert: pnf minSize >= 0
]

{ #category : 'accessor tests' }
UmePNFConverterTest >> testPNFGrammarTerminals [

	| grammar pnf |
	grammar := GncConcatGrammar new.
	pnf := grammar to_pnf.
	self assert: pnf terminals isNotEmpty
]

{ #category : 'accessor tests' }
UmePNFConverterTest >> testPNFGrammarEachNonTerminal [

	| grammar pnf count |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	count := 0.
	pnf eachNonTerminal: [ :nt | count := count + 1 ].
	self assert: count > 0.
	self assert: count equals: pnf nonTerminals size
]

{ #category : 'epsilon tests' }
UmePNFConverterTest >> testNullableDetection [

	| converter |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { #(). { 'B'. 'C' } };
		at: 'B' put: { { 'b' } };
		at: 'C' put: { #() };
		yourself).
	self assert: ((converter findNullable) includes: 'C').
	self assert: ((converter findNullable) includes: 'A').
	self deny: ((converter findNullable) includes: 'B')
]

{ #category : 'left recursion tests' }
UmePNFConverterTest >> testLeftRecursionElimination [

	| converter |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { { 'A'. 'a' }. { 'b' } };
		yourself).
	converter eliminateDirectLeftRecursion: 'A'.
	self assert: (converter grammarMap includesKey: 'A').
	self assert: (converter grammarMap includesKey: 'T_PNF1').
	self deny: ((converter grammarMap at: 'A') anySatisfy: [ :rule |
		rule notEmpty and: [ rule first = 'A' ] ])
]

{ #category : 'left recursion tests' }
UmePNFConverterTest >> testIndirectLeftRecursion [

	| converter |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { { 'B'. 'a' } };
		at: 'B' put: { { 'A'. 'b' }. { 'c' } };
		yourself).
	converter eliminateLeftRecursion.
	"A should now have rules starting with terminals (from B's rules after substitution)"
	converter grammarMap at: 'A' do: [ :rules |
		rules do: [ :rule |
			rule ifNotEmpty: [
				self assert: (rule first isString not or: [
					rule first ~= 'A' ])
					description: 'Left recursion still present in A' ] ] ]
]

{ #category : 'unit tests' }
UmePNFConverterTest >> testUnitProductionDetection [

	| converter |
	converter := UmePNFConverter new.
	self assert: (converter isUnitProduction: { 'A' }).
	self deny: (converter isUnitProduction: { 'a' }).
	self deny: (converter isUnitProduction: { 'A'. 'B' }).
	self deny: (converter isUnitProduction: { })
]

{ #category : 'unit tests' }
UmePNFConverterTest >> testUnitPairComputation [

	| converter pairs |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { { 'B' } };
		at: 'B' put: { { 'b' } };
		yourself).
	pairs := converter computeUnitPairs.
	self assert: ((pairs at: 'A') includes: 'A').
	self assert: ((pairs at: 'A') includes: 'B').
	self assert: ((pairs at: 'B') includes: 'B').
	self deny: ((pairs at: 'B') includes: 'A')
]

{ #category : 'unit tests' }
UmePNFConverterTest >> testUnitElimination [

	| converter |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { { 'B' } };
		at: 'B' put: { { 'b' } };
		yourself).
	converter eliminateUnitProductions.
	"A should now have the non-unit rules of B"
	self assert: ((converter grammarMap at: 'A') anySatisfy: [ :rule |
		rule = { 'b' } ]).
	self deny: ((converter grammarMap at: 'A') anySatisfy: [ :rule |
		rule size = 1 and: [ rule first = 'B' ] ])
]

{ #category : 'conversion tests' }
UmePNFConverterTest >> testGNFConversionProducesTerminalFirstRules [

	| converter |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { { 'B'. 'x' } };
		at: 'B' put: { { 'b' } };
		yourself).
	converter convertToGNF.
	"A should now start with terminal"
	self assert: ((converter grammarMap at: 'A') anySatisfy: [ :rule |
		rule notEmpty and: [ rule first isString not ] ])
]

{ #category : 'conversion tests' }
UmePNFConverterTest >> testGNFConversionHandlesChain [

	| converter |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { { 'B'. 'x' } };
		at: 'B' put: { { 'C'. 'y' } };
		at: 'C' put: { { 'c' } };
		yourself).
	converter convertToGNF.
	"A should start with terminal"
	self assert: ((converter grammarMap at: 'A') allSatisfy: [ :rule |
		rule isEmpty or: [ rule first isString not ] ])
]

{ #category : 'conversion tests' }
UmePNFConverterTest >> testConvertTailIntroducesNewNT [

	| converter |
	converter := UmePNFConverter new.
	converter grammarMap: (Dictionary new
		at: 'A' put: { { 'a'. 'b' } };
		yourself).
	converter convertToGNF.
	"A should now have A -> a NewNT, NewNT -> b"
	self assert: ((converter grammarMap at: 'A') allSatisfy: [ :rule |
		rule isEmpty or: [
			rule first isString not and: [
				(2 to: rule size) allSatisfy: [ :i |
					(rule at: i) isString ] ] ] ])
]

{ #category : 'end-to-end tests' }
UmePNFConverterTest >> testConvertLiteralGrammarEndToEnd [

	| grammar pnf generator |
	grammar := GncLiteralGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	self assert: generator generate equals: 'oui'
]

{ #category : 'end-to-end tests' }
UmePNFConverterTest >> testConvertRangeGrammarEndToEnd [

	| grammar pnf generator string |
	grammar := GncRangeGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	string := generator generate.
	self assert: (string = '3' or: [ string = '4' or: [ string = '5' ] ])
]

{ #category : 'end-to-end tests' }
UmePNFConverterTest >> testConvertDisjunctionGrammarEndToEnd [

	| grammar pnf generator |
	grammar := GncDisjunctionGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	10 timesRepeat: [
		| string |
		string := generator generate.
		self assert: (string = 'oui' or: [ string = 'non' ])
			description: 'Unexpected output: ', string ]
]

{ #category : 'end-to-end tests' }
UmePNFConverterTest >> testConvertConcatGrammarEndToEnd [

	| grammar pnf generator |
	grammar := GncConcatGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	self assert: generator generate equals: 'ouinon'
]

{ #category : 'end-to-end tests' }
UmePNFConverterTest >> testConvertBaseGrammarEndToEnd [

	| grammar pnf generator |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	self assert: (generator generate matchesRegex: '\d+')
]

{ #category : 'end-to-end tests' }
UmePNFConverterTest >> testConvertExpressionGrammarEndToEnd [

	| grammar pnf generator |
	grammar := GncExpressionGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	5 timesRepeat: [
		| string |
		string := generator generate.
		self assert: string isNotEmpty.
		self assert: (UmeGrammarParser accept: string from: grammar)
			description: 'Failed to parse: ', string ]
]

{ #category : 'accessor tests' }
UmePNFConverterTest >> testPNFGrammarStartNonTerminal [

	| grammar pnf |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	self assert: (pnf start isKindOf: GncNonTerminal).
	self assert: pnf start name isNotEmpty
]

{ #category : 'accessor tests' }
UmePNFConverterTest >> testPNFGrammarNonTerminalsAreNonTerminal [

	| grammar pnf |
	grammar := GncBaseGrammar new.
	pnf := grammar to_pnf.
	self assert: (pnf nonTerminals allSatisfy: [ :nt |
		nt isKindOf: GncNonTerminal ])
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testAllRulesStartWithTerminalArit [

	| grammar pnf |
	grammar := AritExpressionGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			rule fragments ifNotEmpty: [
				self assert: (rule fragments first isKindOf: GncTerminal)
					description: 'Rule of ', nt name, ' does not start with terminal' ] ] ]
]

{ #category : 'structural tests' }
UmePNFConverterTest >> testNoLeftRecursionJSON [

	| grammar pnf |
	grammar := JSONGrammar new.
	pnf := grammar to_pnf.
	pnf eachNonTerminal: [ :nt |
		nt rules do: [ :rule |
			rule fragments ifNotEmpty: [
				| first |
				first := rule fragments first.
				(first isKindOf: GncNonTerminal) ifTrue: [
					self assert: first name ~= nt name
						description: 'Left recursion in ', nt name ] ] ] ]
]

{ #category : 'generator tests' }
UmePNFConverterTest >> testPNFGrammarCanGenerateAssociations [

	| grammar pnf generator |
	grammar := AssociationsGrammar new.
	pnf := grammar to_pnf.
	generator := UmeGrammarGenerator new grammar: pnf; maxHeight: 100; maxSize: 100.
	self assert: (generator generate isKindOf: String).
	self assert: generator generate isNotEmpty
]
