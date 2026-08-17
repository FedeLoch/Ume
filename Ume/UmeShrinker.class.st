Class {
	#name : 'UmeShrinker',
	#superclass : 'Object',
	#instVars : [
		'maxIterations',
		'reductionsDone',
		'failedReductionsDone',
		'oracle',
		'grammar'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeShrinker >> asInput: tree [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeShrinker >> checkGrammar: aInput [

	^ UmeGrammarParser accept: aInput from: grammar
]

{ #category : 'shrinking' }
UmeShrinker >> evalInput: input [

	"Returns true if the input triggers the bug, otherwise, it returns false"
	^ oracle evalInput: input
]

{ #category : 'shrinking' }
UmeShrinker >> failedMinimization [

	failedReductionsDone := failedReductionsDone + 1
]

{ #category : 'shrinking' }
UmeShrinker >> grammar [
	
	^ grammar
]

{ #category : 'shrinking' }
UmeShrinker >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'testing' }
UmeShrinker >> initialize [ 
	
	super initialize.
	maxIterations := 1000.
	reductionsDone := 0.
	failedReductionsDone := 0.
]

{ #category : 'shrinking' }
UmeShrinker >> maxIterations: nbIterations [

	maxIterations := nbIterations
]

{ #category : 'shrinking' }
UmeShrinker >> minimizationDone [

	reductionsDone := reductionsDone + 1
]

{ #category : 'shrinking' }
UmeShrinker >> minimizeOne: tree upperBound: bound [

	"Each sublclass must call:
		self minimizationDone -> each time it proceeds to do a reduction ( failed or not )
		self failedMinimization -> each time it proceeds to do a failed reduction
	"
	self subclassResponsibility
]

{ #category : 'shrinking' }
UmeShrinker >> minimizeTree: tree upperBound: bound [

	| currentTree currentSize |
	
	reductionsDone := 0.
	failedReductionsDone := 0.

	currentTree := tree copy.
	currentSize := self sizeOf: currentTree.
	maxIterations timesRepeat: [ | minimized size |
		minimized := self minimizeOne: currentTree upperBound: bound.
		size := self sizeOf: minimized.
		
		(self shouldStop: minimized size: size from: currentTree size: currentSize) ifTrue: [ ^ currentTree ].
		
		currentTree := minimized.
		currentSize := size
	].

	^ currentTree
]

{ #category : 'shrinking' }
UmeShrinker >> oracle [ 
	
	^ oracle 
]

{ #category : 'shrinking' }
UmeShrinker >> oracle: anOracle [

	oracle := anOracle
]

{ #category : 'shrinking' }
UmeShrinker >> percentageInputReduced: tree given: minimizedTree [

	| initialNumOfNodes currentNumOfNodes |
	initialNumOfNodes := self sizeOf: tree.
	currentNumOfNodes := self sizeOf: minimizedTree.

	^ (100 - ((currentNumOfNodes * 100) / initialNumOfNodes)) asFloat
]

{ #category : 'shrinking' }
UmeShrinker >> percentageProblemPreservation: upperBound given: currentBound [

	| baseline current |
	
	baseline := oracle valueBound: upperBound.
	current := oracle valueBound: currentBound.
	
	(baseline = 0) ifTrue: [ ^ 0 ].
	
	^ ((current * 100) / baseline) asFloat
]

{ #category : 'shrinking' }
UmeShrinker >> profiledShrink: input [

	| tree minimizedTree upperBound initialTime totalTime minimizedInput minimizedBound |
	
	initialTime := Time microsecondClockValue.
	(self tree: input) ifNil: [ Error signal: 'Trying to reduce a non valid input' ].
	upperBound := self evalInput: input.

	tree := self tree: input.
	
	minimizedTree := self minimizeTree: tree upperBound: upperBound.	
	totalTime := Time microsecondClockValue - initialTime.
	minimizedInput := self asInput: minimizedTree.
	minimizedBound := self evalInput: minimizedInput.

	^ {
		'originalInput' -> input.
		'minimizedInput' -> minimizedInput.
		'totalTime' -> (Duration microSeconds: totalTime).
		'neededReductions' -> reductionsDone asFloat.
		'failedReductions' -> failedReductionsDone asFloat.
		'%problemPreservation' -> (self percentageProblemPreservation: upperBound given: minimizedBound).
		'%inputReduction' -> (self percentageInputReduced: tree given: minimizedTree).
		'originalBound' -> upperBound.
		'minimizedBound' -> minimizedBound
	} asDictionary
]

{ #category : 'shrinking' }
UmeShrinker >> shouldStop: minimized size: size from: currentTree size: currentSize [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeShrinker >> shrink: input [

	| tree minimizedTree upperBound |

	(self tree: input) ifNil: [ ^ input ].
	upperBound := self evalInput: input.

	tree := self tree: input.
	minimizedTree := self minimizeTree: tree upperBound: upperBound.

	^ self asInput: minimizedTree
]

{ #category : 'shrinking' }
UmeShrinker >> sizeOf: tree [

	^ tree allNodes size
]

{ #category : 'shrinking' }
UmeShrinker >> tree: input [

	self  subclassResponsibility 
]

{ #category : 'testing' }
UmeShrinker >> triggerBug: tree upperBound: originalScore [

	| input |
	
	input := self asInput: tree.

	^ [
		  (oracle accepts: input from: originalScore) and: [
			  self checkGrammar: input ] ]
		  on: Error
		  do: [ :error | false ]
]
