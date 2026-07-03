Class {
	#name : 'GraphExperiment',
	#superclass : 'GrammarBasePathologicalBugMutatorPaperExperiment',
	#category : 'Ume-Paper Experimentation',
	#package : 'Ume',
	#tag : 'Paper Experimentation'
}

{ #category : 'running' }
GraphExperiment >> baseSeed [

	^ 'RSSugiyamaLayout
RSBox
552->882 . 583->865'
]

{ #category : 'running' }
GraphExperiment >> complexSeed [

	^ 'RSHorizontalDominanceTreeLayout
RSPolygon
534->657 . 768->178'
]

{ #category : 'running' }
GraphExperiment >> maxInputSize [

	^ 1000
]

{ #category : 'running' }
GraphExperiment >> methodsToInstrument [

	^ RSLineBuilder package methods, RSClusterRadialTreeLayout package methods
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
	
	graphCodeGenerator := self corpusGenerator: mutators selector: selector.

	^ UmeSchema new
		  receiverConstraint: (UmeConstantGenerator new value: UmeRoassalGrapher);
		  argumentConstraints: { graphCodeGenerator };
		  property: [ :regex :input :result | true ]
]

{ #category : 'running' }
GraphExperiment >> seeds [

	^ { self baseSeed . self complexSeed }
]

{ #category : 'running' }
GraphExperiment >> targetMethod [

	^ UmeRoassalGrapher class >> #run:
]

{ #category : 'running' }
GraphExperiment >> weightedGrammarSchema [

	| graphCodeGenerator |
	
	graphCodeGenerator := UmeGrammarGenerator new grammar: self newGrammar; maxSize: self maxInputSize.

	^ UmeSchema new
		receiverConstraint: (UmeConstantGenerator new value: UmeRoassalGrapher);
		argumentConstraints: { graphCodeGenerator };
		property: [ :regex :input :result | true ].
]
