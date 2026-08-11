Class {
	#name : 'UmeMOPTMutatorSelector',
	#superclass : 'UmeMutatorSelector',
	#instVars : [
		'selectionCounts',
		'successCounts',
		'updatePeriod',
		'selectionCounter',
		'omega',
		'phi',
		'random',
		'maxProbability',
		'minProbability',
		'numberOfSwarms',
		'swarms',
		'lastMutatedSelector',
		'pilotPhaseMax'
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

	(((feedback isNotNil) and: [ feedback isPositive ]) and: [ lastMutatedSelector isNotNil ]) ifTrue: [ 
			successCounts at: lastMutatedSelector put: (successCounts at: lastMutatedSelector) + 1
	]
]

{ #category : 'initialization' }
UmeMOPTMutatorSelector >> initialize [

	super initialize.
	
	numberOfSwarms := 10.
	
	omega := 0.72.
	phi := 1.5.
	updatePeriod := 100.
	selectionCounter := 0.
	successCounts := {}.
	random := Random new.
	
	"how many warm up executions should be done to get the swarms up and running"
	pilotPhaseMax := 100.
]

{ #category : 'initialization' }
UmeMOPTMutatorSelector >> initializeSwarms: mutators [

	| count uniform |

	count := mutators size.
	
	swarms := (1 to: numberOfSwarms) collect: [ :i |
		UmeMOPTSwarm new
			mopt: self;
			initializeSwarm: mutators;
			yourself
	].
	
	uniform := 1.0 / count asFloat.
	
	minProbability := 0.001.
	maxProbability := 0.998.
	
	selectionCounts := Array new: count withAll: 0.
	successCounts := Array new: count withAll: 0.
	lastMutatedSelector := 1.
	selectionCounter := 0.
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
UmeMOPTMutatorSelector >> omega [

	^ omega
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> omega: aFloat [

	omega := aFloat
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> phi [

	^ phi
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> phi: aFloat [

	phi := aFloat
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> random [

	^ random
]

{ #category : 'enumerating' }
UmeMOPTMutatorSelector >> selectMutator: mutators [
	"if the probabilities were not assigned, we initialize them uniformly"

	| swarm isPilotPhase |
	swarms isNil ifTrue: [ self initializeSwarms: mutators ].

	selectionCounter := selectionCounter + 1.
	isPilotPhase := selectionCounter < pilotPhaseMax.
	swarm := isPilotPhase
		         ifTrue: [ "Pilot phase, we take the next swarm in round robin"
			         swarms at: selectionCounter \\ numberOfSwarms + 1 ]
		         ifFalse: [ "not in pilot phase anymore, use the best swarm"
		         self bestSwarm ].

	lastMutatedSelector := swarm selectMutatorFrom: mutators.

	selectionCounts
		at: lastMutatedSelector
		put: (selectionCounts at: lastMutatedSelector) + 1.

	(isPilotPhase or: [selectionCounter \\ updatePeriod = 0]) ifTrue: [
			swarm
				updateProbabilitiesWithSuccesses: successCounts
				onSelections: selectionCounts.
			1 to: mutators size do: [ :i |
					selectionCounts at: i put: 0.
					successCounts at: i put: 0 ] ].

	^ mutators at: lastMutatedSelector
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> selectionCounter [

	^ selectionCounter	
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> selectionCounts [

	^ selectionCounts
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> successCounts [

	^ successCounts
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> updatePeriod [

	^ updatePeriod
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> updatePeriod: anInteger [

	updatePeriod := anInteger
]
