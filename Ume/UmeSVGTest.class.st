Class {
	#name : 'UmeSVGTest',
	#superclass : 'TestCase',
	#instVars : [
		'argumentConstraints',
		'schema',
		'receiverConstraint',
		'runner'
	],
	#category : 'Ume-Framework Tests',
	#package : 'Ume',
	#tag : 'Framework Tests'
}

{ #category : 'running' }
UmeSVGTest >> setUp [

	super setUp.
	self timeLimit: 5 hours.
	
	schema := UmeSchema new
		          receiverConstraint: (UmeConstantGenerator new value: SVGRunner);
		          argumentConstraints: { (self svgGenerator) };
		          score: [ :re :inputs :res | 1 ];
		          property: [ :regex :input :result | true ];
					 method: SVGRunner class >> #run:.


	runner := UmeRunner test: schema for: 20 minutes.
]

{ #category : 'as yet unclassified' }
UmeSVGTest >> svgGenerator [

	| seeds randomGenerator |
	randomGenerator := UmeGrammarGenerator new grammar: SvgPathGrammar new; maxHeight: SmallInteger maxVal; maxSize: 1000.
	seeds := 100 timesCollect: [ :i | randomGenerator gen: nil ].

	^ UmeCorpusGenerator new
		  seeds: seeds;
		  mutationsPerIteration: 3;
		  mutators: {
			(UmeGrammarLiteralsMutator from: SvgPathGrammar new) maxInputSize: 1000.
			(UmeGrammarDerivationMutator from: SvgPathGrammar new) maxInputSize: 1000
		  };
		  heuristic: UmePickBestElementDifferenceHeuristic new
]

{ #category : 'tests' }
UmeSVGTest >> testGuidingByMethodsCalls [ 

	| result methods |
	
	runner guidedByExecutionTime.
	methods := RSSVGPath package methods.
	"runner collectAllCases."
	
	runner methodsToInstrument: methods.
	result := runner run.

	1 halt.
]
