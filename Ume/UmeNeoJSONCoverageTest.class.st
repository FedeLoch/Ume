Class {
	#name : 'UmeNeoJSONCoverageTest',
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

{ #category : 'as yet unclassified' }
UmeNeoJSONCoverageTest >> jsonGenerator [

	^ UmeCorpusGenerator new
		  seeds: self seeds;
		  mutationsPerIteration: 3;
		  mutators: {
			(UmeGrammarLiteralsMutator from: JSONGrammar new) maxInputSize: 1000.
			(UmeGrammarDerivationMutator from: JSONGrammar new) maxInputSize: 1000
		  };
		  heuristic: UmePickBestElementDifferenceHeuristic new
]

{ #category : 'running' }
UmeNeoJSONCoverageTest >> seeds [

	^ { '{}' . '{"n":true,"n":[],"x":6}' }
]

{ #category : 'running' }
UmeNeoJSONCoverageTest >> setUp [

	super setUp.
	self timeLimit: 5 hours.
	
	schema := UmeSchema new
		          receiverConstraint: (UmeConstantGenerator new value: NeoJSONReader);
		          argumentConstraints: { self jsonGenerator };
		          property: [ :regex :input :result | true ];
					 method: NeoJSONReader class >> #fromString:.

	runner := UmeRunner test: schema for: 1 hour.
]

{ #category : 'tests' }
UmeNeoJSONCoverageTest >> testGuidingByCoverage [

	| result methods |
	
	runner guidedByCoverage.
	methods := NeoJSONReader package methods.
	"runner collectAllCases."
	runner collectOnlyOutliers.
	
	runner methodsToInstrument: methods.
	result := runner run.

	1 halt.
]
