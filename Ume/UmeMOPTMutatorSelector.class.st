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
		'random'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'feedback' }
UmeMOPTMutatorSelector >> feed: feedback [

	feedback isPositive ifTrue: [
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

	(probabilities isNil or: [ probabilities size ~= mutators size ]) ifTrue: [
		| count uniform |
		count := mutators size.
		uniform := 1.0 / count asFloat.
		probabilities := (1 to: count) collect: [ :i | uniform ].
		selectionCounts := Array new: count withAll: 0.
		successCounts := Array new: count withAll: 0.
		velocities := Array new: count withAll: 0.0.
		lastIndex := 1.
		selectionCounter := 0
	]
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
	self initializeProbabilities: mutators.
	total := probabilities sum.
	roll := total * random next.
	cumulative := 0.0.

	probabilities withIndexDo: [ :prob :index |
		cumulative := cumulative + prob.
		roll <= cumulative ifTrue: [
			lastIndex := index.
			selectionCounts at: index put: (selectionCounts at: index) + 1.
			selectionCounter := selectionCounter + 1.
			selectionCounter >= updatePeriod ifTrue: [ self updateProbabilities ].
			^ mutators at: index
		]
	].

	"Fallback — should not reach here"
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

	| totalEffectiveness targetProbabilities sum |

	totalEffectiveness := 0.0.
	targetProbabilities := Array new: probabilities size.

	1 to: probabilities size do: [ :i |
		| sel suc eff |
		sel := selectionCounts at: i.
		suc := successCounts at: i.
		eff := sel > 0
			ifTrue: [ suc / sel asFloat ]
			ifFalse: [ 0.0 ].
		eff := eff + 0.001.
		targetProbabilities at: i put: eff.
		totalEffectiveness := totalEffectiveness + eff
	].

	1 to: targetProbabilities size do: [ :i |
		targetProbabilities at: i put: (targetProbabilities at: i) / totalEffectiveness
	].

	sum := 0.0.
	1 to: probabilities size do: [ :i |
		| target velocity newProb |
		target := targetProbabilities at: i.
		velocity := velocities at: i.
		velocity := (omega * velocity) + (phi * random next * (target - (probabilities at: i))).
		velocities at: i put: velocity.
		newProb := (probabilities at: i) + velocity.
		newProb := newProb max: 0.0.
		probabilities at: i put: newProb.
		sum := sum + newProb
	].

	sum > 0
		ifTrue: [
			1 to: probabilities size do: [ :i |
				probabilities at: i put: (probabilities at: i) / sum
			]
		]
		ifFalse: [
			1 to: probabilities size do: [ :i |
				probabilities at: i put: 1.0 / probabilities size
			]
		].

	1 to: selectionCounts size do: [ :i |
		selectionCounts at: i put: 0.
		successCounts at: i put: 0
	].
	selectionCounter := 0
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> velocities [

	^ velocities
]
