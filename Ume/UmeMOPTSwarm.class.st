Class {
	#name : 'UmeMOPTSwarm',
	#superclass : 'Object',
	#instVars : [
		'probabilities',
		'velocities',
		'localBestEfficiencies',
		'localBestProbabilities',
		'mopt',
		'swarmSucccesses',
		'swarmSelections'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'accessing' }
UmeMOPTSwarm >> efficiency [

	| selections |
	selections := swarmSelections sum.
	selections = 0 ifTrue: [ ^ 0 ].
	^ swarmSucccesses sum / selections
]

{ #category : 'initialization' }
UmeMOPTSwarm >> initializeSwarm: mutators [

	| count notNormalizedProbabilities probabilitySum |
	count := mutators size.

	swarmSucccesses := Array new: count withAll: 0.
	swarmSelections := Array new: count withAll: 0.

	localBestEfficiencies := Array new: count withAll: 0.
	localBestProbabilities := Array new: count withAll: 0.5.

	notNormalizedProbabilities := (1 to: count) collect: [ :i | mopt random next ].
	probabilitySum := notNormalizedProbabilities sum.

	probabilities := notNormalizedProbabilities collect: [ :e | e / probabilitySum ].
	velocities := (1 to: count) collect: [ :i | 0.1 ].
]

{ #category : 'accessing' }
UmeMOPTSwarm >> mopt [

	^ mopt
]

{ #category : 'accessing' }
UmeMOPTSwarm >> mopt: anObject [

	mopt := anObject
]

{ #category : 'accessing' }
UmeMOPTSwarm >> mutatorWeights [

	^ probabilities"selectionCounts"
]

{ #category : 'accessing' }
UmeMOPTSwarm >> probabilities [

	^ probabilities
]

{ #category : 'as yet unclassified' }
UmeMOPTSwarm >> selectMutatorFrom: mutatorList [
	"get the total probability sum"

	| total roll cumulative |
	total := probabilities sum.
	"throw a coin"
	roll := total * mopt random next.
	cumulative := 0.0.

	"look for the lucky one"
	probabilities withIndexDo: [ :prob :index |
			cumulative := cumulative + prob.
			roll <= cumulative ifTrue: [ ^ index ] ].

	"in case the coin is too high is because the lucky one is the last one"
	^ probabilities size
]

{ #category : 'updating' }
UmeMOPTSwarm >> updateProbabilitiesWithSuccesses: localSuccesses onSelections: localSelections [

	| totalLocalEfficiency localEfficiencies sum |
	totalLocalEfficiency := 0.0.
	localEfficiencies := Array new: probabilities size.

	1 to: probabilities size do: [ :i |
			| localSuccess localSelection localEfficiency |
			
			"Cumulate the total number of selections and successes of this swarm"
			swarmSucccesses at: i put: (swarmSucccesses at: i) + (localSuccesses at: i).
			swarmSelections at: i put: (swarmSelections at: i) + (localSelections at: i).		
			
			localSuccess := localSuccesses at: i.
			localSelection := localSelections at: i.
			localEfficiency := localSelection = 0
				                   ifTrue: [ 0 ]
				                   ifFalse: [ localSuccess / localSelection ].
			localEfficiencies at: i put: localEfficiency + 0.001.
			totalLocalEfficiency := totalLocalEfficiency
			                        + (localEfficiency + 0.001) ].

	"Normalize efficiencies"
	localEfficiencies := localEfficiencies collect: [ :p |
		                     p / totalLocalEfficiency ].

	"Update the local best efficiencies and positions
	We are going to use it to update the new velocicies"
	localEfficiencies withIndexDo: [ :localEfficiency :i |
			localEfficiency > (localBestEfficiencies at: i) ifTrue: [
					localBestEfficiencies at: i put: localEfficiency.
					localBestProbabilities at: i put: (probabilities at: i) ] ].

	sum := 0.0.
	1 to: probabilities size do: [ :i |
			| localBestProbability velocity newProb |
			"update the velocity of each one"
			localBestProbability := localBestProbabilities at: i.
			velocity := velocities at: i.
			velocity := mopt omega * velocity + (mopt phi * mopt random next
			             * (localBestProbability - (probabilities at: i))).
			velocities at: i put: velocity.

			"re compute the probability of each one"
			newProb := (probabilities at: i) + velocity.
			newProb := newProb
				           min: mopt maxProbability
				           max: mopt minProbability.
			probabilities at: i put: newProb.
			sum := sum + newProb ].

	"Normalize the swarm probabilities, and make them uniform if they reached 0"
	probabilities := sum > 0
		                 ifTrue: [ probabilities collect: [ :p | p / sum ] ]
		                 ifFalse: [
		                 probabilities collect: [ :_ |
			                 1.0 / probabilities size ] ]
]

{ #category : 'accessing' }
UmeMOPTSwarm >> velocities [

	^ velocities
]
