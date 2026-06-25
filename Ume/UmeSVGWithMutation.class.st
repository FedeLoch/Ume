Class {
	#name : 'UmeSVGWithMutation',
	#superclass : 'UmeSVGTest',
	#instVars : [
		'runner'
	],
	#category : 'Ume-Framework Tests',
	#package : 'Ume',
	#tag : 'Framework Tests'
}

{ #category : 'running' }
UmeSVGWithMutation >> setUp [ 

	super setUp.
	runner := UmeRunner test: schema for: 5 minutes
]

{ #category : 'as yet unclassified' }
UmeSVGWithMutation >> svgGenerator [ 

	| seeds |
	seeds := { 'M797,632.3c0,44.2-15.7,82.2-47.5,113.5' }.

	^ UmeCorpusGenerator new
		  seeds: seeds;
		  mutationsPerIteration: 3;
		  mutators: { (UmeGrammarLiteralsMutator from: SvgPathGrammar new) };
		  heuristic: UmePickBestElementDifferenceHeuristic new
]

{ #category : 'tests' }
UmeSVGWithMutation >> testGuidingByMethodsCalls [ 

	| result |
	
	runner guidedByMethodsCalls.
	result := runner run.
	1 halt.
]
