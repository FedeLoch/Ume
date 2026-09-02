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
	#category : 'Ume-Generic Tools',
	#package : 'Ume',
	#tag : 'Generic Tools'
}

{ #category : 'accessing' }
UmeMOPTSwarm >> efficiency [

	| selections |
	
	selections := swarmSelections sum.
	
	selections isZero ifTrue: [ ^ 0 ].
	
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
UmeMOPTSwarm >> probabilities [

	^ probabilities
]

{ #category : 'as yet unclassified' }
UmeMOPTSwarm >> selectCandidateFrom: mutatorList [

	| total roll cumulative |
	"get the total probability sum"
	total := probabilities sum.
	"throw a coin"
	roll := total * mopt random next.
	cumulative := 0.0.

	"look for the lucky one"
	probabilities withIndexDo: [ :prob :index |
			cumulative := cumulative + prob.
			roll <= cumulative ifTrue: [
				swarmSelections at: index put: (swarmSelections at: index) + 1.
				^ index ] ].

	"in case the coin is too high is because the lucky one is the last one"
	swarmSelections atLast: 1 put: (swarmSelections atLast: 1) + 1.
	^ probabilities size
]

{ #category : 'accessing' }
UmeMOPTSwarm >> swarmSelections [

	^ swarmSelections
]

{ #category : 'accessing' }
UmeMOPTSwarm >> swarmSucccesses [

	^ swarmSucccesses
]

{ #category : 'updating' }
UmeMOPTSwarm >> updateProbabilitiesWithSuccesses: localSuccesses onSelections: localSelections [

	| totalLocalEfficiency localEfficiencies sum |
	totalLocalEfficiency := 0.0.
	localEfficiencies := Array new: probabilities size.

	1 to: probabilities size do: [ :i |
			| localSuccess localSelection localEfficiency |
			localSuccess := localSuccesses at: i.
			localSelection := localSelections at: i.

			"Cumulate the total number of selections and successes of this swarm"
			swarmSucccesses at: i put: (swarmSucccesses at: i) + localSuccess.
			
			localEfficiency := localSelection = 0
				                   ifTrue: [ 0 ]
				                   ifFalse: [ localSuccess / localSelection ].
			localEfficiencies at: i put: localEfficiency.
			totalLocalEfficiency := totalLocalEfficiency
			                        + localEfficiency ].

	"Normalize efficiencies if totalLocalEfficiency is not 0"
	totalLocalEfficiency = 0 ifFalse: [ localEfficiencies :=  localEfficiencies collect: [ :p | p / totalLocalEfficiency ] ].

	"Update the local best efficiencies and positions
	We are going to use it to update the new velocicies"
	localEfficiencies withIndexDo: [ :localEfficiency :i |
			localEfficiency > (localBestEfficiencies at: i) ifTrue: [
					localBestEfficiencies at: i put: localEfficiency.
					localBestProbabilities at: i put: (probabilities at: i) ] ].

	sum := 0.0.
	1 to: probabilities size do: [ :i |
			| localBestProbability globalBestProbability velocity newProb randomValue currentProbability |
			"update the velocity of each one"
			localBestProbability := localBestProbabilities at: i.
			globalBestProbability := mopt globalBestProbabilities at: i.
			velocity := velocities at: i.
			randomValue := mopt random next.
			currentProbability := (probabilities at: i).
			velocity := mopt inertia * velocity + (randomValue * (localBestProbability - currentProbability))
														+ (randomValue * (globalBestProbability - currentProbability)) .
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
