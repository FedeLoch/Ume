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
UmeShrinker >> evalInput: input [

	self subclassResponsibility 
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

	| currentTree |
	
	reductionsDone := 0.
	failedReductionsDone := 0.

	"This minimize as much as possible the input".
	currentTree := tree copy.
	maxIterations timesRepeat: [ | minimized |
		minimized := self minimizeOne: currentTree upperBound: bound.
		(minimized = currentTree) ifTrue: [ ^ currentTree ].
		currentTree := minimized.
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
	
	baseline := self problemPresence: upperBound.
	current := self problemPresence: currentBound.
	
	^ ((current * 100) / baseline) asFloat
]

{ #category : 'shrinking' }
UmeShrinker >> problemPresence: bound [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeShrinker >> profiledShrink: input [

	| tree minimizedTree upperBound initialTime totalTime minimizedInput |
	
	initialTime := Time microsecondClockValue.
	(self tree: input) ifNil: [ Error signal: 'Trying to reduce a non valid input' ].
	upperBound := self evalInput: input.

	tree := self tree: input.
	
	minimizedTree := self minimizeTree: tree upperBound: upperBound.	
	totalTime := Time microsecondClockValue - initialTime.
	minimizedInput := self asInput: minimizedTree.
	
	^ {
		'totalTime' -> (Duration microSeconds: totalTime).
		'neededReductions' -> reductionsDone.
		'failedReductions' -> failedReductionsDone.
		'%problemPreservation' -> (self percentageProblemPreservation: upperBound given: (self evalInput: minimizedInput)).
		'%inputReduction' -> (self percentageInputReduced: tree given: minimizedTree).
		'minimizedInput' -> minimizedInput
	}
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
UmeShrinker >> triggerBug: score upperBound: originalScore [

	self subclassResponsibility 
]
