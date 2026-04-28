Class {
	#name : 'UmeNeoJsonTest',
	#superclass : 'UmeAPITest',
	#instVars : [
		'schema',
		'receiver',
		'argument'
	],
	#category : 'Ume-API Tests',
	#package : 'Ume',
	#tag : 'API Tests'
}

{ #category : 'running' }
UmeNeoJsonTest >> setUp [

	| mutator generator|
	super setUp.
	
	mutator := UmeGrammarLiteralsMutator  from: JSONGrammar new.
	mutator maxInputSize: 30.

	"Corpus-based generator starts with a seed and evolves it."
	generator := UmeCorpusGenerator new
		  seeds: { '{"n":true,"x":6}' };
		  mutationsPerIteration: 1;
		  mutators: { mutator };
		  heuristic: UmePickBestElementDifferenceHeuristic new.

	receiver := UmeObjectConstraint new
		generator: (UmeConstantGenerator new value: NeoJSONReader).
	
	argument := {
		UmeObjectConstraint new generator: generator
	}.

	schema := UmeSchema new
		receiverConstraint: receiver;
		argumentConstraints: argument ;
		score: [ :re :inputs :res | 1 ];
		property: [ :regex :input :result | true ].


]

{ #category : 'tests' }
UmeNeoJsonTest >> testNeoJsonPerformance [

	|runner|
	runner := ((UmeRunner test: NeoJSONReader class >> #fromString: from: schema for: 20 seconds) "guidedByMethodsCalls") run.
	self assertSuccess:runner.
	self assert:(runner totalTime >= 20 seconds).
	

]
