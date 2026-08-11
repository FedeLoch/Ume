Class {
	#name : 'UmeMOPTMutatorSelector',
	#superclass : 'UmeMutatorSelector',
	#instVars : [
		'probabilities',
		'selectionCounts',
		'successCounts',
		'velocities',
		'lastIndex',
		'updatePeriod',
		'selectionCounter',
		'omega',
		'phi',
		'random',
		'localBestEfficiencies',
		'localBestProbabilities',
		'maxProbability',
		'minProbability'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'feedback' }
UmeMOPTMutatorSelector >> feed: feedback [

	(((feedback isNotNil) and: [ feedback isPositive ]) and: [ lastIndex isNotNil ]) ifTrue: [ 
			successCounts at: lastIndex put: (successCounts at: lastIndex) + 1
	]
]

{ #category : 'initialization' }
UmeMOPTMutatorSelector >> initialize [

	super initialize.
	omega := 0.72.
	phi := 1.5.
	updatePeriod := 100.
	selectionCounter := 0.
	successCounts := {}.
	random := Random new
]

{ #category : 'initialization' }
UmeMOPTMutatorSelector >> initializeProbabilities: mutators [

	| count uniform |

	count := mutators size.
	uniform := 1.0 / count asFloat.
	
	localBestEfficiencies := Array new: count withAll: 0.
	localBestProbabilities := Array new: count withAll: 0.
	minProbability := 0.001.
	maxProbability := 0.998.
	
	probabilities := (1 to: count) collect: [ :i | uniform ].
	selectionCounts := Array new: count withAll: 0.
	successCounts := Array new: count withAll: 0.
	velocities := Array new: count withAll: 0.0.
	lastIndex := 1.
	selectionCounter := 0.
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> lastSelectedIndex [

	^ lastIndex
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> mutatorWeights [

	^ probabilities"selectionCounts"
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
UmeMOPTMutatorSelector >> probabilities [

	^ probabilities
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> random [

	^ random
]

{ #category : 'enumerating' }
UmeMOPTMutatorSelector >> selectMutator: mutators [

	| total roll cumulative |

	"if the probabilities were not assigned, we initialize them uniformly"
	(probabilities isNil or: [ probabilities size ~= mutators size ]) ifTrue: [
		self initializeProbabilities: mutators.
	].

	"get the total probability sum"
	total := probabilities sum.
	"throw a coin"
	roll := total * random next.
	cumulative := 0.0.

	"look for the lucky one"
	probabilities withIndexDo: [ :prob :index |
		cumulative := cumulative + prob.
		roll <= cumulative ifTrue: [
			"found, now we update the last selected and the counter"
			lastIndex := index.
			selectionCounts at: index put: (selectionCounts at: index) + 1.
			selectionCounter := selectionCounter + 1.
			selectionCounter >= updatePeriod ifTrue: [ self updateProbabilities ].
	
			"return the lucky one"
			^ mutators at: index
		]
	].
	
	"in case the coin is too high is because the lucky one is the last one"
	lastIndex := probabilities size.

	^ mutators last
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

{ #category : 'updating' }
UmeMOPTMutatorSelector >> updateProbabilities [

	| totalLocalEfficiency localEfficiencies sum |

	totalLocalEfficiency := 0.0.
	localEfficiencies := Array new: probabilities size.

	"recreate the the targetProbabilities based on their effectiveness"
	1 to: probabilities size do: [ :i | | localSelections localSuccesses localEfficiency |
		localSelections := selectionCounts at: i.
		localSuccesses := successCounts at: i.
		localEfficiency := localSelections > 0 ifTrue: [ localSuccesses / localSelections asFloat ] ifFalse: [ 0.0 ].
		localEfficiency := localEfficiency + 0.001.
		localEfficiencies at: i put: localEfficiency.
		totalLocalEfficiency := totalLocalEfficiency + localEfficiency
	].

	"Normalize efficiencies"
	localEfficiencies := localEfficiencies collect: [ :p | p / totalLocalEfficiency ].

	"Update the local best efficiencies and positions
	We are going to use it to update the new velocicies"
	1 to: localEfficiencies do: [ :i |
		(localEfficiencies at: i) > (localBestEfficiencies at: i)
			ifTrue: [
				localBestEfficiencies at: i put: (localEfficiencies at: i).
				localBestProbabilities at: i put: (probabilities at: i).
			]
	].

	sum := 0.0.
	1 to: probabilities size do: [ :i | | localBestProbability velocity newProb |
		"update the velocity of each one"
		localBestProbability := localBestProbabilities at: i.
		velocity := velocities at: i.
		velocity := (omega * velocity) + (phi * random next * (localBestProbability - (probabilities at: i))).
		velocities at: i put: velocity.
		
		"re compute the probability of each one"
		newProb := (probabilities at: i) + velocity.
		newProb := newProb min: maxProbability max: minProbability.
		probabilities at: i put: newProb.
		sum := sum + newProb
	].

	"Normalize the swarm probabilities, and make them uniform if they reached 0"
	probabilities :=  ((sum > 0) ifTrue: [
		probabilities collect: [ :p | p / sum ] ] ifFalse: [
		probabilities collect: [ :_ | 1.0 / probabilities size ].
	]).

	"restart the success and selection counters"
	(1 to: selectionCounts size) do: [ :i |
		selectionCounts at: i put: 0.
		successCounts at: i put: 0
	].

	selectionCounter := 0
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> velocities [

	^ velocities
]
