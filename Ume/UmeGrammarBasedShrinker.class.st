Class {
	#name : 'UmeGrammarBasedShrinker',
	#superclass : 'UmeShrinker',
	#instVars : [
		'evaluator',
		'feedbackEvaluator',
		'threshold',
		'programBlock',
		'classesToProfile',
		'memo'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> candidates: root [
	
	| worstReward worst |
	worstReward := SmallInteger maxVal.
	worst := OrderedCollection new.
	
	root allNodes do: [ :node | | reward |
		reward := node reward: grammar root: root.
		(reward < worstReward) ifTrue: [ worstReward := reward . worst := OrderedCollection new ].
		(reward = worstReward) ifTrue: [ worst add: node ]
	].

	^ worst
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> classesToProfile [

	^ classesToProfile 
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> classesToProfile: someClassesToProfile [

	classesToProfile := someClassesToProfile 
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> evalInput: input [

	| profilingResult umeCase program |
	
	memo at: input ifAbsentPut: [
		program := PBAProgram from: [ programBlock value: input ] forClasses: classesToProfile.

		[ 	profilingResult := evaluator analyzer analyze: program.
			umeCase := UmeTest new result: (UmeEvalSuccess new profilingResult: profilingResult)
		] on: Error do: [ ^ nil ].

		(feedbackEvaluator eval: umeCase) absoluteImprovement
	].
	
	^ memo at: input
]

{ #category : 'accessing' }
UmeGrammarBasedShrinker >> evaluator [
	
	^ evaluator
]

{ #category : 'accessing' }
UmeGrammarBasedShrinker >> evaluator: anEvaluator [

	evaluator := anEvaluator
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> feedbackEvaluator [

	^ feedbackEvaluator 
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> feedbackEvaluator: aFeedbackEvaluator [

	feedbackEvaluator := aFeedbackEvaluator 
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> initialize [ 
	
	super initialize.
	threshold := 0.95.
	programBlock := nil.
	classesToProfile := nil.
	feedbackEvaluator := nil.
	grammar := nil.
	memo := Dictionary new.
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> isValidTree: node [

	| input derivation |
	input := node asInput.

	[ derivation := self parse: input ] on: Error do: [ ^ false ].
	derivation ifNil: [ ^ false ].

	^ derivation asInput = input
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> minimizeOne: tree upperBound: upperBound [

	| seen allNodes |
	
	seen := Set new.
	allNodes := tree allNodes asSet.
	
	"TODO: We need to recompute the candidates each time we accept a new version of out tree input"
	(self candidates: tree) do: [ :candidate | | parent trigger |
		(seen includes: candidate) ifFalse: [
			seen add: candidate.
			parent := candidate parent.
			(parent notNil and: [ allNodes includes: candidate ]) ifTrue: [ | index |
				"TODO: add a memoization to know if the candidate is removable or not"
				index := parent children indexOf: candidate.
				parent replaceChildAt: index with: candidate emptyTree.
				
				trigger := self triggerBug: (self evalInput: tree asInput) upperBound: upperBound.
				((self isValidTree: tree) and: [ trigger ]) ifFalse: [ parent replaceChildAt: index with: candidate ]
		 	]
		]
	].

	^ tree 
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> programBlock [

	^ programBlock 
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> programBlock: aProgramBlock [

	programBlock := aProgramBlock 
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> resetMemoization [

	memo := Dictionary new.
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> threshold [

	^ threshold 
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> threshold: aThreshold [

	threshold := aThreshold.
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> tree: input [

	^ self parse: input
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> triggerBug: score upperBound: originalScore [

	score ifNil: [ ^ false ].

	^ score >= (originalScore * threshold)
]
