Class {
	#name : 'UmeGrammarBasedShrinkerTest',
	#superclass : 'TestCase',
	#instVars : [
		'feedbackEvaluator'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'tests' }
UmeGrammarBasedShrinkerTest >> updateFeedbackEvaluatorWith: feedback [

	feedbackEvaluator guide setBase: feedback.

]
