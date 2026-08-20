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
	delta := after collectWithIndex: [ :a :index |
		a - (before at: index ifAbsent: 0)
	].

	self assert: delta sum equals: 1
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testFeedWithNegativeFeedbackDoesNotTrackSuccess [

	| before after delta |
	
	before := selector successCounts copy.
	
	selector selectMutator: mutators.
	selector feed: (UmeFeedback from: 'test' improvement: 0 values: Dictionary new).
	
	after := selector successCounts.
	delta := after collectWithIndex: [ :a :index |
		a - (before at: index ifAbsent: 0)
	].

	self assert: delta sum equals: 0
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testMultipleSelectionsIncrementSelectionCounts [

	50 timesRepeat: [ selector selectMutator: mutators ].
	self assert: (selector selectionCounts sum) equals: 50
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testProbabilitiesSumToOne [

	| sums |
	selector selectMutator: mutators.
	sums := selector swarms collect: [ :each | each probabilities sum ].

	sums do: [ :sum | self assert: (sum - 1.0) abs < 0.0001 ]
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
		result := singleSelector selectMutator: singleMutators.
		self assert: result equals: singleMutators first
	]
]

{ #category : 'tests' }
UmeMOPTMutatorSelectorTest >> testUpdatePeriodTriggersNewIteration [

	| period |
	period := selector updatePeriod.
	period - 1 timesRepeat: [ selector selectMutator: mutators ].

	self assert: selector selectionCounter equals: period - 1.

	selector selectMutator: mutators.

	selector selectionCounts do: [ :each | self assert: each equals: 0 ].
	selector successCounts do: [ :each | self assert: each equals: 0 ]
]
