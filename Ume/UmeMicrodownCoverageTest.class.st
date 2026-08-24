Class {
	#name : 'UmeMicrodownCoverageTest',
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
UmeMicrodownCoverageTest >> microdownFileGenerator [

	^ UmeCorpusGenerator new
		  seeds: self seeds;
		  mutationsPerIteration: 3;
		  mutators: {
			(UmeGrammarLiteralsMutator from: ExtendedMarkdownGrammar new) maxInputSize: 1000.
			(UmeGrammarDerivationMutator from: ExtendedMarkdownGrammar new) maxInputSize: 1000
		  };
		  heuristic: UmePickBestElementDifferenceHeuristic new
]

{ #category : 'running' }
UmeMicrodownCoverageTest >> seeds [

	^ { 'a' . '# Header
	** This is a line comment **
	
	```
	code
	```
   
   	![Pharo is cool](http://pharo.org)
	
   	- list
   	1. ordered list 

  	`in text` and for Pharo hyperlinks to class, method and package: 
  	`Point`, `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`

  	References: @ref@' }
]

{ #category : 'running' }
UmeMicrodownCoverageTest >> setUp [

	super setUp.
	self timeLimit: 5 hours.
	
	schema := UmeSchema new
		          receiverConstraint: (UmeConstantGenerator new value: Microdown);
		          argumentConstraints: { self microdownFileGenerator };
		          property: [ :regex :input :result | true ];
					 method: Microdown class >> #parse:.

	runner := UmeRunner test: schema for: 1 hour.
]

{ #category : 'tests' }
UmeMicrodownCoverageTest >> testGuidingByCoverage [

	| result methods |
	
	runner guidedByCoverage.
	methods := Microdown package methods.
	"runner collectAllCases."
	runner collectOnlyOutliers.
	
	runner methodsToInstrument: methods.
	result := runner run.

	1 halt.
]
