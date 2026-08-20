Class {
	#name : 'UmeMOPTMutatorSelector',
	#superclass : 'UmeMutatorSelector',
	#instVars : [
		'updatePeriod',
		'selectionCounter',
		'random',
		'maxProbability',
		'minProbability',
		'numberOfSwarms',
		'swarms',
		'lastMutatedSelector',
		'pilotPhaseMax',
		'inertia',
		'globalBestProbabilities',
		'iterationSuccessCounts',
		'iterationSelectionCounts',
		'globalSuccessCounts'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> bestSwarm [

	| bestEfficiency bestSwarm |
	bestEfficiency := Float negativeInfinity.
	swarms do: [ :swarm |
			swarm efficiency > bestEfficiency ifTrue: [
					bestEfficiency := swarm efficiency.
					bestSwarm := swarm ] ].
	^ bestSwarm
]

{ #category : 'feedback' }
UmeMOPTMutatorSelector >> feed: feedback [

	((feedback isNotNil and: [ feedback isPositive ]) and: [ lastMutatedSelector isNotNil ]) ifTrue: [
			iterationSuccessCounts at: lastMutatedSelector put: (iterationSuccessCounts at: lastMutatedSelector) + 1.
			globalSuccessCounts at: lastMutatedSelector put: (globalSuccessCounts at: lastMutatedSelector) + 1 ]
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> globalBestProbabilities [

	^ globalBestProbabilities
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> globalBestProbabilities: anObject [

	globalBestProbabilities := anObject
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> inertia [

	^ inertia
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> inertia: aFloat [

	inertia := aFloat
]

{ #category : 'initialization' }
UmeMOPTMutatorSelector >> initialize [

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
UmeMOPTMutatorSelector >> initializeSwarms: mutators [

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
	lastMutatedSelector := 1.
	selectionCounter := 0
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> lastSelectedIndex [

	^ lastMutatedSelector
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> maxProbability [

	^ maxProbability
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> maxProbability: anObject [

	maxProbability := anObject
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> minProbability [

	^ minProbability
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> minProbability: anObject [

	minProbability := anObject
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> mutatorWeights [

	"This may be called before the swarms are initialized??"
	swarms ifNil: [ ^ nil ].
	^ self bestSwarm probabilities
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> random [

	^ random
]

{ #category : 'enumerating' }
UmeMOPTMutatorSelector >> selectMutator: mutators [

	| swarm isPilotPhase |
	swarms ifNil: [ self initializeSwarms: mutators ].

	selectionCounter := selectionCounter + 1.
	isPilotPhase := selectionCounter < (pilotPhaseMax * numberOfSwarms).
	swarm := isPilotPhase
		         ifTrue: [ "Pilot phase, we take the next swarm in round robin" swarms at: selectionCounter \\ numberOfSwarms + 1 ]
		         ifFalse: [ "not in pilot phase anymore, use the best swarm" self bestSwarm ].

	lastMutatedSelector := swarm selectMutatorFrom: mutators.

	iterationSelectionCounts at: lastMutatedSelector put: (iterationSelectionCounts at: lastMutatedSelector) + 1.

	selectionCounter \\ updatePeriod = 0 ifTrue: [
			self updateGlobalBestProbabilitiesWithSuccesses: globalSuccessCounts.
			swarm updateProbabilitiesWithSuccesses: iterationSuccessCounts onSelections: iterationSelectionCounts.
			1 to: mutators size do: [ :i |
					iterationSelectionCounts at: i put: 0.
					iterationSuccessCounts at: i put: 0 ] ].

	^ mutators at: lastMutatedSelector
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> selectionCounter [

	^ selectionCounter	
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> selectionCounts [

	^ iterationSelectionCounts
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> successCounts [

	^ iterationSuccessCounts
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> swarms [

	^ swarms
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> swarms: anObject [

	swarms := anObject
]

{ #category : 'as yet unclassified' }
UmeMOPTMutatorSelector >> updateGlobalBestProbabilitiesWithSuccesses: successes [

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
UmeMOPTMutatorSelector >> updatePeriod [

	^ updatePeriod
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> updatePeriod: anInteger [

	updatePeriod := anInteger
]
