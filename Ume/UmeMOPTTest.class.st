Class {
	#name : 'UmeMOPTTest',
	#superclass : 'TestCase',
	#instVars : [
		'mutator1',
		'mutator2',
		'mutator3',
		'mutators',
		'mopt'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'running' }
UmeMOPTTest >> setUp [

	super setUp.
	mopt := UmeMOPT new.
	mutator1 := UmeMutator mutate: [ :x | x ].
	mutator2 := UmeMutator mutate: [ :x | x, 'a' ].
	mutator3 := UmeMutator mutate: [ :x | x copyFrom: 2 to: x size ].
	mutators := { mutator1. mutator2. mutator3 }
]

{ #category : 'tests' }
UmeMOPTTest >> testAllSwarmsAreSelectedInPilotPhase [

	mopt pilotPhaseMax * mopt numberOfSwarms timesRepeat: [ mopt selectCandidate: mutators ].
	mopt swarms do: [ :swarm | self assert: swarm swarmSelections sum equals: mopt pilotPhaseMax ]
]

{ #category : 'tests' }
UmeMOPTTest >> testAllSwarmsAreSelectedOnce [

	10 timesRepeat: [ mopt selectCandidate: mutators ].
	mopt swarms do: [ :swarm | self assert: swarm swarmSelections sum equals: 1 ]
]

{ #category : 'tests' }
UmeMOPTTest >> testFeedTracksSuccesses [

	| before after delta |

	before := mopt iterationSuccessCounts copy.
	
	mopt selectCandidate: mutators.
	mopt feed: (UmeFeedback from: 'test' improvement: 1 values: Dictionary new).
	
	after := mopt iterationSuccessCounts.
	delta := after collectWithIndex: [ :a :index |
		a - (before at: index ifAbsent: 0)
	].

	self assert: delta sum equals: 1
]

{ #category : 'tests' }
UmeMOPTTest >> testFeedWithNegativeFeedbackDoesNotTrackSuccess [

	| before after delta |
	
	before := mopt iterationSuccessCounts copy.
	
	mopt selectCandidate: mutators.
	mopt feed: (UmeFeedback from: 'test' improvement: 0 values: Dictionary new).
	
	after := mopt iterationSuccessCounts.
	delta := after collectWithIndex: [ :a :index |
		a - (before at: index ifAbsent: 0)
	].

	self assert: delta sum equals: 0
]

{ #category : 'tests' }
UmeMOPTTest >> testIterationsCountsAreReset [

	| expectedArray |
	expectedArray := Array new: mutators size withAll: 0.
	
	mopt selectCandidate: mutators.
	self deny: mopt iterationSelectionCounts equals: expectedArray.

	mopt updatePeriod - 1 timesRepeat: [ mopt selectCandidate: mutators ].
	self assert: mopt iterationSelectionCounts equals: expectedArray.
	self assert: mopt iterationSuccessCounts equals: expectedArray
]

{ #category : 'tests' }
UmeMOPTTest >> testMultipleSelectionsIncrementSelectionCounts [

	50 timesRepeat: [ mopt selectCandidate: mutators ].
	self assert: (mopt iterationSelectionCounts sum) equals: 50
]

{ #category : 'tests' }
UmeMOPTTest >> testProbabilitiesSumToOne [

	| sums |
	mopt selectCandidate: mutators.
	sums := mopt swarms collect: [ :each | each probabilities sum ].

	sums do: [ :sum | self assert: (sum - 1.0) abs < 0.0001 ]
]

{ #category : 'tests' }
UmeMOPTTest >> testSelectReturnsAMutator [

	| result |

	result := mopt selectCandidate: mutators.
	self assert: (mutators includes: result)
]

{ #category : 'tests' }
UmeMOPTTest >> testSelectReturnsDifferentMutators [

	| results |

	results := Set new.
	100 timesRepeat: [ results add: (mopt selectCandidate: mutators) ].

	self assert: results size > 1
]

{ #category : 'tests' }
UmeMOPTTest >> testSingleMutatorAlwaysSelected [

	| singleMutators result |

	singleMutators := { UmeMutator mutate: [ :x | x, 'b' ] }.

	100 timesRepeat: [
		result := mopt selectCandidate: singleMutators.
		self assert: result equals: singleMutators first
	]
]

{ #category : 'tests' }
UmeMOPTTest >> testSwarmProbabilitiesAreUpdated [

	| oldProba |
	mopt initializeSwarms: mutators.
	oldProba := mopt swarms collect: #probabilities.
	
	mopt updatePeriod timesRepeat: [ mopt selectCandidate: mutators ].
	self deny: (mopt swarms collect: #probabilities) equals: oldProba
]

{ #category : 'tests' }
UmeMOPTTest >> testUpdatePeriodTriggersNewIteration [

	| period |
	period := mopt updatePeriod.
	period - 1 timesRepeat: [ mopt selectCandidate: mutators ].

	self assert: mopt selectionCounter equals: period - 1.

	mopt selectCandidate: mutators.

	mopt iterationSelectionCounts do: [ :each | self assert: each equals: 0 ].
	mopt iterationSuccessCounts do: [ :each | self assert: each equals: 0 ]
]
