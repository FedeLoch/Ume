Class {
	#name : 'UmeAPINeoJsonTest',
	#superclass : 'UmeAPITest',
	#instVars : [
		'schema',
		'receiver',
		'argument'
	],
	#category : 'Ume Tests-API Tests',
	#package : 'Ume Tests',
	#tag : 'API Tests'
}

{ #category : 'running' }
UmeAPINeoJsonTest >> setUp [

	| mutator generator|
	super setUp.
	
	mutator := UmeGrammarDerivationMutator  from: JSONGrammar new.
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
		property: [ :regex :input :result | true ];
		method: NeoJSONReader class >> #fromString:.


]

{ #category : 'tests' }
UmeAPINeoJsonTest >> successful: umeResult [

	^ umeResult topCases isEmpty not
]

{ #category : 'tests' }
UmeAPINeoJsonTest >> testNeoJsonPerformance [

	| runner result |

	runner := UmeRunner test: NeoJSONReader class >> #fromString: from: schema for: 5 seconds.
	
	result := runner run.

	self assertSuccess: result.
	self assert: (result totalTime >= 2 seconds).

]

{ #category : 'tests' }
UmeAPINeoJsonTest >> testNeoJsonPerformanceCount [

	| runner result |

	runner := UmeRunner test: schema times: 2.
	runner collectAllCases.
	result := runner run.

	self assertSuccess: result.
	self assert: (result numberOfGeneratedTests ) equals: 2.

]

{ #category : 'tests' }
UmeAPINeoJsonTest >> testNeoJsonPerformanceNewAPI [

	| runner result |

	runner := UmeRunner test: schema.
	
	result := runner run.

	self assertSuccess: result.
	

]

{ #category : 'tests' }
UmeAPINeoJsonTest >> testNeoJsonPerformanceOutliersOnly [

	| runner result |
	runner := UmeRunner test: schema.

	result := runner run.

	self assertSuccess: result.

	(result tests select: [ :test | test isError not ]) do: [ :test |
		self assert: test feedback improvement > 0 ].
	self assert: result numberOfGeneratedTests > 0
]

{ #category : 'tests' }
UmeAPINeoJsonTest >> testNeoJsonPerformanceTimer [

	| runner result |

	runner := UmeRunner test: schema for: 5 seconds.
	
	result := runner run.

	self assertSuccess: result.
	self assert: (result totalTime >= 2 seconds).

]
