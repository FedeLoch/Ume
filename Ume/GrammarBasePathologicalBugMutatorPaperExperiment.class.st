Class {
	#name : 'GrammarBasePathologicalBugMutatorPaperExperiment',
	#superclass : 'Object',
	#instVars : [
		'experimentTime',
		'times',
		'schemas'
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
GrammarBasePathologicalBugMutatorPaperExperiment >> grammarDerivationsSchema [

	^ self schemaCorpusWith: self grammarDerivationMutators selector: UmeWeightedMutatorSelector new
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> grammarLiteralMutators [

	^ { (UmeGrammarLiteralsMutator from: self newGrammar) maxInputSize: self maxInputSize }
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> grammarLiteralsSchema [

	^ self schemaCorpusWith: self grammarLiteralMutators selector: UmeWeightedMutatorSelector new
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> initialize [ 

	super initialize.
	experimentTime := 1 hour.
	times := 20.
	schemas := {
		'weighted-grammar-base' -> self weightedGrammarSchema.
		'stochastic-base' -> self stochasticSchema.
		'grammar-literals' -> self grammarLiteralsSchema.
		'grammar-derivations' -> self grammarDerivationsSchema.
		'weighted-scheduling' -> self weightSelectionSchedulerSchema.
		'random-scheduling' -> self randomSelectionSchedulerSchema.
		'mopt-scheduling' -> self moptSelectionSchedulerSchema
	} asDictionary.
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
GrammarBasePathologicalBugMutatorPaperExperiment >> moptSelectionSchedulerSchema [

	^ self schemaCorpusWith: (
		self grammarLiteralMutators,
		self grammarDerivationMutators,
		self stochasticMutators
	) selector: UmeMOPTMutatorSelector new
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
GrammarBasePathologicalBugMutatorPaperExperiment >> randomSelectionSchedulerSchema [

	^ self schemaCorpusWith: (
		self grammarLiteralMutators,
		self grammarDerivationMutators,
		self stochasticMutators
	) selector: UmeRandomMutatorSelector new
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> run: config iteration: i [

	| schema runner result fileName |
	
	fileName := self csvFileName: config iteration: i.

	schema := self schema: config.
	
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
GrammarBasePathologicalBugMutatorPaperExperiment >> schema: config [

	^ schemas at: config
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> schemaCorpusWith: mutators selector: selector [

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> seeds [

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> stochasticMutators [

	^ { (UmeAddByteMutator new maxInputSize: self maxInputSize).
		  UmeByteFlipMutator new.
		  UmeDelByteMutator new }
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> stochasticSchema [

	^ self schemaCorpusWith: self stochasticMutators selector: UmeWeightedMutatorSelector new
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> targetMethod [

	self subclassResponsibility 
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> weightSelectionSchedulerSchema [

	^ self schemaCorpusWith: (
		self grammarLiteralMutators,
		self grammarDerivationMutators,
		self stochasticMutators
	) selector: UmeWeightedMutatorSelector new
]

{ #category : 'running' }
GrammarBasePathologicalBugMutatorPaperExperiment >> weightedGrammarSchema [

	self subclassResponsibility 
]
