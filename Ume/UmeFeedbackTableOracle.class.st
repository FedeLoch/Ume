Class {
	#name : 'UmeFeedbackTableOracle',
	#superclass : 'UmeInputOracle',
	#instVars : [
		'threshold',
		'programBlock',
		'classesToProfile',
		'feedbackEvaluator',
		'evaluator',
		'memo'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'testing' }
UmeFeedbackTableOracle >> classesToProfile [

	^ classesToProfile 
]

{ #category : 'testing' }
UmeFeedbackTableOracle >> classesToProfile: someClassesToProfile [

	classesToProfile := someClassesToProfile 
]

{ #category : 'shrinking' }
UmeFeedbackTableOracle >> evalInput: input [

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
UmeFeedbackTableOracle >> evaluator [
	
	^ evaluator
]

{ #category : 'accessing' }
UmeFeedbackTableOracle >> evaluator: anEvaluator [

	evaluator := anEvaluator
]

{ #category : 'shrinking' }
UmeFeedbackTableOracle >> feedbackEvaluator [

	^ feedbackEvaluator 
]

{ #category : 'shrinking' }
UmeFeedbackTableOracle >> feedbackEvaluator: aFeedbackEvaluator [

	feedbackEvaluator := aFeedbackEvaluator 
]

{ #category : 'accessing' }
UmeFeedbackTableOracle >> initialize [

	super initialize.
	threshold := 0.95.
	programBlock := nil.
	classesToProfile := nil.
	feedbackEvaluator := nil.
	memo := Dictionary new.
]

{ #category : 'shrinking' }
UmeFeedbackTableOracle >> resetMemoization [

	memo := Dictionary new.
]

{ #category : 'accessing' }
UmeFeedbackTableOracle >> threshold [

	^ threshold
]

{ #category : 'accessing' }
UmeFeedbackTableOracle >> threshold: aThreshold [

	threshold := aThreshold
]
