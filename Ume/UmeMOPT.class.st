Class {
	#name : 'UmeMOPT',
	#superclass : 'Object',
	#instVars : [
		'updatePeriod',
		'selectionCounter',
		'random',
		'maxProbability',
		'minProbability',
		'numberOfSwarms',
		'swarms',
		'pilotPhaseMax',
		'inertia',
		'globalBestProbabilities',
		'iterationSuccessCounts',
		'iterationSelectionCounts',
		'globalSuccessCounts',
		'lastSelectedCandidateIndex',
		'corePhaseMax',
		'currentSwarm',
		'pendingFlush'
	],
	#category : 'Ume-Generic Tools',
	#package : 'Ume',
	#tag : 'Generic Tools'
}

{ #category : 'accessing' }
UmeMOPT >> bestSwarm [

	| bestEfficiency bestSwarm |
	bestEfficiency := Float negativeInfinity.
	swarms do: [ :swarm |
			swarm efficiency > bestEfficiency ifTrue: [
					bestEfficiency := swarm efficiency.
					bestSwarm := swarm ] ].
	^ bestSwarm
]

{ #category : 'accessing' }
UmeMOPT >> corePhaseMax [

	^ corePhaseMax
]

{ #category : 'accessing' }
UmeMOPT >> corePhaseMax: anInteger [

	corePhaseMax := anInteger
]

{ #category : 'accessing' }
UmeMOPT >> currentSwarm [

	^ currentSwarm
]

{ #category : 'accessing' }
UmeMOPT >> cycleLength [

	^ self pilotPhaseLength + corePhaseMax
]

{ #category : 'updating' }
UmeMOPT >> feed: feedback [

	(self isPositiveFeedback: feedback) ifTrue: [ self increaseSuccessLastSelection ].
	"The feedback of the last selection of a period has arrived, so the period can be closed"
	pendingFlush ifTrue: [ self flushIteration ]
]

{ #category : 'updating' }
UmeMOPT >> flushIteration [
	"Close the current period: the statistics gathered since the last flush belong to the swarm that made those selections"

	pendingFlush := false.
	(currentSwarm isNil or: [ iterationSelectionCounts sum = 0 ]) ifTrue: [ ^ self ].

	self updateGlobalBestProbabilitiesWithSuccesses: globalSuccessCounts.
	currentSwarm updateProbabilitiesWithSuccesses: iterationSuccessCounts onSelections: iterationSelectionCounts.
	1 to: iterationSelectionCounts size do: [ :mutatorIndex |
		iterationSelectionCounts at: mutatorIndex put: 0.
		iterationSuccessCounts at: mutatorIndex put: 0 ]
]

{ #category : 'accessing' }
UmeMOPT >> globalBestProbabilities [

	^ globalBestProbabilities
]

{ #category : 'accessing' }
UmeMOPT >> globalBestProbabilities: anObject [

	globalBestProbabilities := anObject
]

{ #category : 'accessing' }
UmeMOPT >> globalSuccessCounts [

	^ globalSuccessCounts
]

{ #category : 'accessing' }
UmeMOPT >> globalSuccessCounts: anObject [

	globalSuccessCounts := anObject
]

{ #category : 'updating' }
UmeMOPT >> increaseSuccessLastSelection [

	iterationSuccessCounts at: lastSelectedCandidateIndex put: (iterationSuccessCounts at: lastSelectedCandidateIndex) + 1.
	globalSuccessCounts at: lastSelectedCandidateIndex put: (globalSuccessCounts at: lastSelectedCandidateIndex) + 1
]

{ #category : 'accessing' }
UmeMOPT >> inertia [

	^ inertia
]

{ #category : 'accessing' }
UmeMOPT >> inertia: aFloat [

	inertia := aFloat
]

{ #category : 'initialization' }
UmeMOPT >> initialize [

	super initialize.

	numberOfSwarms := 10.

	inertia := 0.72.
	updatePeriod := 100.
	selectionCounter := 0.
	random := Random new.
	iterationSuccessCounts := {  }.
	
	"how many consecutive selections each swarm performs during the pilot phase"
	pilotPhaseMax := 100.
	"how many selections the best swarm performs during the core phase, before going back to the pilot phase"
	corePhaseMax := pilotPhaseMax * numberOfSwarms.
	pendingFlush := false
]

{ #category : 'initialization' }
UmeMOPT >> initializeSwarms: mutators [

	| mutatorsSize |
	mutatorsSize := mutators size.

	swarms := (1 to: numberOfSwarms) collect: [ :_ |
		UmeMOPTSwarm new mopt: self; initializeSwarm: mutators; yourself
	].

	globalBestProbabilities := Array new: mutatorsSize withAll: 0.5.

	minProbability := 0.001.
	maxProbability := 0.998.

	globalSuccessCounts := Array new: mutatorsSize withAll: 0.
	iterationSelectionCounts := Array new: mutatorsSize withAll: 0.
	iterationSuccessCounts := Array new: mutatorsSize withAll: 0.
	"No candidate has been selected yet, so no success can be credited"
	lastSelectedCandidateIndex := nil.
	currentSwarm := nil.
	pendingFlush := false.
	selectionCounter := 0
]

{ #category : 'updating' }
UmeMOPT >> isPositiveFeedback: feedback [

	^ (feedback isNotNil and: [ feedback isPositive ]) and: [ lastSelectedCandidateIndex isNotNil ]
]

{ #category : 'accessing' }
UmeMOPT >> iterationSelectionCounts [

	^ iterationSelectionCounts
]

{ #category : 'accessing' }
UmeMOPT >> iterationSuccessCounts [

	^ iterationSuccessCounts
]

{ #category : 'accessing' }
UmeMOPT >> lastSelectedCandidateIndex [

	^ lastSelectedCandidateIndex
]

{ #category : 'accessing' }
UmeMOPT >> lastSelectedCandidateIndex: anObject [

	lastSelectedCandidateIndex := anObject
]

{ #category : 'accessing' }
UmeMOPT >> maxProbability [

	^ maxProbability
]

{ #category : 'accessing' }
UmeMOPT >> maxProbability: anObject [

	maxProbability := anObject
]

{ #category : 'accessing' }
UmeMOPT >> minProbability [

	^ minProbability
]

{ #category : 'accessing' }
UmeMOPT >> minProbability: anObject [

	minProbability := anObject
]

{ #category : 'accessing' }
UmeMOPT >> numberOfSwarms [

	^ numberOfSwarms
]

{ #category : 'accessing' }
UmeMOPT >> numberOfSwarms: anObject [

	numberOfSwarms := anObject
]

{ #category : 'accessing' }
UmeMOPT >> pilotPhaseMax [

	^ pilotPhaseMax
]

{ #category : 'accessing' }
UmeMOPT >> pilotPhaseLength [

	^ pilotPhaseMax * numberOfSwarms
]

{ #category : 'accessing' }
UmeMOPT >> pilotPhaseMax: anInteger [

	pilotPhaseMax := anInteger
]

{ #category : 'accessing' }
UmeMOPT >> random [

	^ random
]

{ #category : 'enumerating' }
UmeMOPT >> selectCandidate: mutators [

	| swarm |
	swarms ifNil: [ self initializeSwarms: mutators ].

	"The feedback of the previous selection never arrived, close the period now"
	pendingFlush ifTrue: [ self flushIteration ].

	swarm := self swarmForNextSelection.
	"Statistics are never shared between swarms"
	(currentSwarm notNil and: [ swarm ~~ currentSwarm ]) ifTrue: [ self flushIteration ].
	currentSwarm := swarm.

	selectionCounter := selectionCounter + 1.
	lastSelectedCandidateIndex := swarm selectCandidateFrom: mutators.
	iterationSelectionCounts at: lastSelectedCandidateIndex put: (iterationSelectionCounts at: lastSelectedCandidateIndex) + 1.

	"The period is closed once the feedback of this selection arrives (see #feed:)"
	selectionCounter \\ updatePeriod = 0 ifTrue: [ pendingFlush := true ].

	^ mutators at: lastSelectedCandidateIndex
]

{ #category : 'accessing' }
UmeMOPT >> selectionCounter [

	^ selectionCounter	
]

{ #category : 'accessing' }
UmeMOPT >> swarms [

	^ swarms
]

{ #category : 'accessing' }
UmeMOPT >> swarms: anObject [

	swarms := anObject
]

{ #category : 'enumerating' }
UmeMOPT >> swarmForNextSelection [
	"Pilot phase: each swarm performs pilotPhaseMax consecutive selections.
	 Core phase: the most efficient swarm performs corePhaseMax selections.
	 Then the cycle starts again, as in MOPT (Lyu et al., USENIX Security 2019)"

	| position |
	position := selectionCounter \\ self cycleLength.
	^ position < self pilotPhaseLength
		ifTrue: [ swarms at: position // pilotPhaseMax + 1 ]
		ifFalse: [ self bestSwarm ]
]

{ #category : 'updating' }
UmeMOPT >> updateGlobalBestProbabilitiesWithSuccesses: successes [

	| totalSuccesses |
	totalSuccesses := successes sum.
	1 to: globalBestProbabilities size do: [ :i |
			| particleSuccesses |
			particleSuccesses := successes at: i.
			globalBestProbabilities at: i put: (totalSuccesses = 0
					 ifTrue: [ 0.5 ]
					 ifFalse: [ particleSuccesses / totalSuccesses ]) ]
]

{ #category : 'accessing' }
UmeMOPT >> updatePeriod [

	^ updatePeriod
]
