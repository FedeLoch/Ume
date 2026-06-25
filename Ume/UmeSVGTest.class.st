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

	| methods |
	super setUp.
	self timeLimit: 5 hours.
	
	schema := UmeSchema new
		          receiverConstraint: (UmeConstantGenerator new value: SVGRunner);
		          argumentConstraints: (self svgGenerator);
		          score: [ :re :inputs :res | 1 ];
		          property: [ :regex :input :result | true ];
					 method: SVGRunner class >> #run:.


	runner := UmeRunner test: schema for: 20 seconds.
	methods := RSSVGPath package methods.
	
	runner methodsToInstrument: methods.
]

{ #category : 'as yet unclassified' }
UmeSVGTest >> svgGenerator [

	| seeds |
	seeds := { 'M797,632.3c0,44.2-15.7,82.2-47.5,113.5' }.

	^ UmeCorpusGenerator new
		  seeds: seeds;
		  mutationsPerIteration: 100;
		  mutators: {
"			(UmeGrammarLiteralsMutator from: SvgPathGrammar new) maxInputSize: 2000."
			(UmeGrammarDerivationMutator from: SvgPathGrammar new) maxInputSize: 2000
		  };
		  heuristic: UmePickBestElementDifferenceHeuristic new
]

{ #category : 'tests' }
UmeSVGTest >> testGuidingByMethodsCalls [ 

	| result |
	
	runner guidedByExecutionTime.
	result := runner run.

	1 halt.
]
