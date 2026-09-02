Class {
	#name : 'GrammarBasePathologicalBugMutatorPaperExperiment',
	#superclass : 'Object',
	#instVars : [
		'experimentTime',
		'times'
	],
	#category : 'Ume-PerfUme Experimentation',
	#package : 'Ume',
	#tag : 'PerfUme Experimentation'
}

{ #category : 'as yet unclassified' }
GrammarBasePathologicalBugMutatorPaperExperiment class >> getResults [

	"TODO"

	^ self new allPathNames collect: [ :file | STON fromStream: file asFileReference readStream ]
]

{ #category : 'as yet unclassified' }
GrammarBasePathologicalBugMutatorPaperExperiment class >> getResults: sourcePath [

	"TODO"

	^ self new allPathNames collect: [ :file | STON fromStream: (sourcePath, file) asFileReference readStream ]
]

{ #category : 'as yet unclassified' }
GrammarBasePathologicalBugMutatorPaperExperiment class >> getResults: sourcePath at: position [

	"TODO"

	^ STON fromStream: (sourcePath, (self new allPathNames at: position)) asFileReference readStream
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment class >> run: confName [

	^ self new runConf: confName
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment class >> run: confName seeds: numberOfSeeds [

	^ self new runConf: confName seeds: numberOfSeeds
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> corpusGenerator: mutators selector: selector [

	^ UmeCorpusGenerator new
		  seeds: self seeds deepCopy;
		  mutationsPerIteration: self mpi;
		  mutators: mutators;
		  mutatorSelector: selector;
		  heuristic: UmePickBestElementDifferenceHeuristic new.
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> csvFileName: config iteration: iteration [

	^ self name, '-', config, '-', iteration asString, '.csv'
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> experimentTime [

	^ experimentTime
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> experimentTime: aDuration [

	experimentTime := aDuration 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> grammarDerivationMutators [

	^ { (UmeGrammarDerivationMutator from: self newGrammar) maxInputSize: self maxInputSize }
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> grammarDerivationsSchema: nSeeds [ 

	^ self schemaCorpusWith: self grammarDerivationMutators selector: UmeWeightedMutatorSelector new seeds: nSeeds
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> grammarLiteralMutators [

	^ { (UmeGrammarLiteralsMutator from: self newGrammar) maxInputSize: self maxInputSize }
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> grammarLiteralsSchema: seeds [

	^ self schemaCorpusWith: self grammarLiteralMutators selector: UmeWeightedMutatorSelector new seeds: seeds
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> initialize [ 

	super initialize.
	experimentTime := 1 hour.
	times := 20.
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> maxInputSize [

	^ SmallInteger maxVal 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> methodsToInstrument [

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> moptSelectionSchedulerSchema: nSeeds [ 

	^ self schemaCorpusWith: (
		self grammarLiteralMutators,
		self grammarDerivationMutators,
		self stochasticMutators
	) selector: UmeMOPTMutatorSelector new seeds: nSeeds
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> mpi [

	^ 3
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> name [

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> newGrammar [

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> randomSelectionSchedulerSchema: nSeeds [

	^ self schemaCorpusWith: (
		self grammarLiteralMutators,
		self grammarDerivationMutators,
		self stochasticMutators
	) selector: UmeRandomMutatorSelector new seeds: nSeeds
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> run: config iteration: i [

	^ self run: config iteration: i seeds: 100
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> run: config iteration: i seeds: numberOfSeeds [

	| schema runner result fileName |
	
	fileName := self csvFileName: config iteration: i.

	schema := self schema: config seeds: numberOfSeeds.
	
	runner := UmeRunner test: self targetMethod from: schema for: self experimentTime.
	
	"We collect all cases, not only outliers"
	runner collectAllCases.
	
	"Guided by methods called"
	runner guidedByMethodsCalls.
	
	"Specify methods to instrument"
	runner methodsToInstrument: self methodsToInstrument.

	"Run the Experiment"	
	result := runner run.

	"We export the result as csv"
	result exportAsCSV: fileName.
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> runConf: confName [

	(1 to: times) do: [ :i |
		Smalltalk garbageCollect. "We perform a garbageCollect before each execution"
		self run: confName iteration: i
	]
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> runConf: confName seeds: numberOfSeeds [

	(1 to: times) do: [ :i |
		Smalltalk garbageCollect. "We perform a garbageCollect before each execution"
		self run: confName iteration: i seeds: numberOfSeeds
	]
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> schema: config [

	^ self schema: config seeds: 100
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> schema: config seeds: numberOfSeeds [

	| schemas |
	schemas := {
		'weighted-grammar-base' -> ([ self weightedGrammarSchema ]).
		'stochastic-base' -> ([ self stochasticSchema: numberOfSeeds ]).
		'grammar-literals' -> ([ self grammarLiteralsSchema: numberOfSeeds ]).
		'grammar-derivations' -> ([ self grammarDerivationsSchema: numberOfSeeds ]).
		'weighted-scheduling' -> ([ self weightSelectionSchedulerSchema: numberOfSeeds ]).
		'random-scheduling' -> ([ self randomSelectionSchedulerSchema: numberOfSeeds ]).
		'mopt-scheduling' -> ([ self moptSelectionSchedulerSchema: numberOfSeeds ])
	} asDictionary.

	^ (schemas at: config) value
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> schemaCorpusWith: mutators selector: selector seeds: nSeeds [

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> seeds: nSeeds [ 

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> stochasticMutators [

	^ { (UmeAddByteMutator new maxInputSize: self maxInputSize).
		  UmeByteFlipMutator new.
		  UmeDelByteMutator new }
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> stochasticSchema: nSeeds [

	^ self schemaCorpusWith: self stochasticMutators selector: UmeWeightedMutatorSelector new seeds: nSeeds
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> targetMethod [

	self subclassResponsibility 
]

{ #category : 'accessing' }
GrammarBasePathologicalBugMutatorPaperExperiment >> times [

	^ times
]

{ #category : 'accessing' }
GrammarBasePathologicalBugMutatorPaperExperiment >> times: anObject [

	times := anObject
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> weightSelectionSchedulerSchema: numberOfSeeds [ 

	^ self schemaCorpusWith: (
		self grammarLiteralMutators,
		self grammarDerivationMutators,
		self stochasticMutators
	) selector: UmeWeightedMutatorSelector new seeds: numberOfSeeds
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> weightedGrammarSchema [

	self subclassResponsibility 
]
