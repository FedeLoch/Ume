Class {
	#name : 'UmeMOPTMutatorSelectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'selector',
		'mutator1',
		'mutator2',
		'mutator3',
		'mutators'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'running' }
UmeMOPTMutatorSelectorTest >> setUp [

	super setUp.
	selector := UmeMOPTMutatorSelector new.
	mutator1 := UmeMutator mutate: [ :x | x ].
	mutator2 := UmeMutator mutate: [ :x | x, 'a' ].
	mutator3 := UmeMutator mutate: [ :x | x copyFrom: 2 to: x size ].
	mutators := { mutator1. mutator2. mutator3 }
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testFeedTracksSuccesses [

	| before after delta |
	before := selector successCounts copy.
	selector selectMutator: mutators.
	selector feed: (UmeFeedback from: 'test' improvement: 1 values: Dictionary new).
	after := selector successCounts.
	delta := after with: before collect: [ :a :b | a - b ].
	self assert: delta sum equals: 1
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testFeedWithNegativeFeedbackDoesNotTrackSuccess [

	| before after delta |
	before := selector successCounts copy.
	selector selectMutator: mutators.
	selector feed: (UmeFeedback from: 'test' improvement: 0 values: Dictionary new).
	after := selector successCounts.
	delta := after with: before collect: [ :a :b | a - b ].
	self assert: delta sum equals: 0
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testMultipleSelectionsIncrementSelectionCounts [

	50 timesRepeat: [ selector selectMutator: mutators ].
	self assert: (selector selectionCounts sum) equals: 50
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testOmegAndPhiAccessors [

	self assert: selector omega equals: 0.72.
	self assert: selector phi equals: 1.5.

	selector omega: 0.5.
	selector phi: 2.0.
	self assert: selector omega equals: 0.5.
	self assert: selector phi equals: 2.0
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testProbabilitiesStartUniform [

	selector selectMutator: mutators.
	selector probabilities do: [ :p |
		self assert: (p - (1.0 / 3 asFloat)) abs < 0.0001
	]
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testProbabilitiesSumToOne [

	| sum |
	selector selectMutator: mutators.
	sum := selector probabilities sum.
	self assert: (sum - 1.0) abs < 0.0001
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testSelectReturnsAMutator [

	| result |
	result := selector selectMutator: mutators.
	self assert: (mutators includes: result)
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testSelectReturnsDifferentMutators [

	| results |
	results := Set new.
	100 timesRepeat: [ results add: (selector selectMutator: mutators) ].
	self assert: results size > 1
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testSingleMutatorAlwaysSelected [

	| singleMutators singleSelector result |
	singleMutators := { UmeMutator mutate: [ :x | x, 'b' ] }.
	singleSelector := UmeMOPTMutatorSelector new.
	100 timesRepeat: [
		result := singleSelector select: singleMutators.
		self assert: result equals: singleMutators first
	]
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testUpdatePeriodTriggersPSOUpdate [

	| period |
	period := selector updatePeriod.
	period - 1 timesRepeat: [ selector selectMutator: mutators ].
	self assert: selector selectionCounter equals: period - 1.
	selector selectMutator: mutators.
	self assert: selector selectionCounter equals: 0
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testUpdateProbabilitiesResetsCounters [

	10 timesRepeat: [
		selector selectMutator: mutators.
		selector feed: (UmeFeedback from: 'test' improvement: 1 values: Dictionary new)
	].

	selector updateProbabilities.
	selector selectionCounts do: [ :c | self assert: c equals: 0 ].
	selector successCounts do: [ :c | self assert: c equals: 0 ]
]
