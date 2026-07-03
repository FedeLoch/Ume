Class {
	#name : 'GraphExperiment',
	#superclass : 'GrammarBasePathologicalBugMutatorPaperExperiment',
	#category : 'Ume-Paper Experimentation',
	#package : 'Ume',
	#tag : 'Paper Experimentation'
}

{ #category : 'running' }
GraphExperiment >> baseSeed [

	1 halt.
]

{ #category : 'running' }
GraphExperiment >> complexSeed [

	1 halt.
]

{ #category : 'running' }
GraphExperiment >> maxInputSize [

	^ 1000
]

{ #category : 'running' }
GraphExperiment >> methodsToInstrument [

	^ RSLineBuilder package methods
]

{ #category : 'running' }
GraphExperiment >> name [

	^ 'PharoGraphs'
]

{ #category : 'running' }
GraphExperiment >> newGrammar [

	^ RoassalGraphGrammar new
]

{ #category : 'running' }
GraphExperiment >> schemaCorpusWith: mutators selector: selector [

	| graphCodeGenerator |
	
	graphCodeGenerator := UmeGraphCodeParserGenerator new inputGenerator: (
		self corpusGenerator: mutators selector: selector
	).

	^ UmeSchema new
		  receiverConstraint: (UmeConstantGenerator new value: UmeCodeRunner);
		  argumentConstraints: { graphCodeGenerator };
		  property: [ :regex :input :result | true ]
]

{ #category : 'running' }
GraphExperiment >> seeds [

	^ { self baseSeed . self complexSeed }
]

{ #category : 'running' }
GraphExperiment >> targetMethod [

	^ UmeCodeRunner class >> #run:
]

{ #category : 'running' }
GraphExperiment >> weightedGrammarSchema [

	| graphCodeGenerator |
	
	graphCodeGenerator := UmeGraphCodeParserGenerator new inputGenerator: (
		UmeGrammarGenerator new grammar: self newGrammar; maxSize: self maxInputSize).

	^ UmeSchema new
		receiverConstraint: (UmeConstantGenerator new value: UmeCodeRunner);
		argumentConstraints: { graphCodeGenerator };
		property: [ :regex :input :result | true ].
]
