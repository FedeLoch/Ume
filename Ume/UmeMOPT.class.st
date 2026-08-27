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
		'lastSelectedCandidateIndex'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
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

{ #category : 'updating' }
UmeMOPT >> feed: feedback [

	((feedback isNotNil and: [ feedback isPositive ]) and: [ lastSelectedCandidateIndex isNotNil ]) ifTrue: [
			iterationSuccessCounts at: lastSelectedCandidateIndex put: (iterationSuccessCounts at: lastSelectedCandidateIndex) + 1.
			globalSuccessCounts at: lastSelectedCandidateIndex put: (globalSuccessCounts at: lastSelectedCandidateIndex) + 1 ]
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
	
	"how many warm up executions should be done to get the swarms up and running"
	pilotPhaseMax := 100
]

{ #category : 'initialization' }
UmeMOPT >> initializeSwarms: mutators [

	| count |
	count := mutators size.

	swarms := (1 to: numberOfSwarms) collect: [ :i |
			          UmeMOPTSwarm new
				          mopt: self;
				          initializeSwarm: mutators;
				          yourself ].

	globalBestProbabilities := Array new: count withAll: 0.5.

	minProbability := 0.001.
	maxProbability := 0.998.

	globalSuccessCounts := Array new: count withAll: 0.
	iterationSelectionCounts := Array new: count withAll: 0.
	iterationSuccessCounts := Array new: count withAll: 0.
	lastSelectedCandidateIndex := 1.
	selectionCounter := 0
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
UmeMOPT >> random [

	^ random
]

{ #category : 'enumerating' }
UmeMOPT >> selectCandidate: mutators [

	| swarm isPilotPhase |
	swarms ifNil: [ self initializeSwarms: mutators ].

	selectionCounter := selectionCounter + 1.
	isPilotPhase := selectionCounter < (pilotPhaseMax * numberOfSwarms).
	swarm := isPilotPhase
		         ifTrue: [ "Pilot phase, we take the next swarm in round robin" swarms at: selectionCounter \\ numberOfSwarms + 1 ]
		         ifFalse: [ "not in pilot phase anymore, use the best swarm" self bestSwarm ].

	lastSelectedCandidateIndex := swarm selectCandidateFrom: mutators.

	iterationSelectionCounts at: lastSelectedCandidateIndex put: (iterationSelectionCounts at: lastSelectedCandidateIndex) + 1.

	selectionCounter \\ updatePeriod = 0 ifTrue: [
			self updateGlobalBestProbabilitiesWithSuccesses: globalSuccessCounts.
			swarm updateProbabilitiesWithSuccesses: iterationSuccessCounts onSelections: iterationSelectionCounts.
			1 to: mutators size do: [ :i |
					iterationSelectionCounts at: i put: 0.
					iterationSuccessCounts at: i put: 0 ] ].

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
