Class {
	#name : 'UmeMicrodownPerfuzzWithGrammarMutatorTest',
	#superclass : 'UmeMicrodownTest',
	#instVars : [
		'runner'
	],
	#category : 'Ume-Framework Tests',
	#package : 'Ume',
	#tag : 'Framework Tests'
}

{ #category : 'running' }
UmeMicrodownPerfuzzWithGrammarMutatorTest >> markdownGenerator [

	^ UmeCorpusGenerator new
		  seeds: { self seed };
		  mutationsPerIteration: 100;
		  mutators: {
				(UmeGrammarLiteralsMutator from: ExtendedMarkdownGrammar new)
			};
		  heuristic: UmePickBestElementDifferenceHeuristic new
]

{ #category : 'running' }
UmeMicrodownPerfuzzWithGrammarMutatorTest >> setUp [

	super setUp.
	runner := UmeRunner test: schema for: 5 minutes.
]

{ #category : 'tests' }
UmeMicrodownPerfuzzWithGrammarMutatorTest >> testGuidingByMethodsCalls [ 

	| result |
	runner guidedByMethodsCalls.
	result := runner run.
	1 halt.
]
