Class {
	#name : 'UmeScoreGuide',
	#superclass : 'UmeFeedbackGuide',
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'accessing' }
UmeScoreGuide >> category: value [

	^ value
]

{ #category : 'as yet unclassified' }
UmeScoreGuide >> tableOfValue [

	^ evaluator customMetricsTable
]

{ #category : 'accessing' }
UmeScoreGuide >> values: case [

	^ { 'score' -> (self category: case score) } asDictionary
]
