Class {
	#name : 'UmeErrorsGuide',
	#superclass : 'UmeFeedbackGuide',
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'accessing' }
UmeErrorsGuide >> category: value [

	^ value
]

{ #category : 'as yet unclassified' }
UmeErrorsGuide >> tableOfValue [

	^ evaluator errorTable
]

{ #category : 'accessing' }
UmeErrorsGuide >> values: case [

	case isError ifFalse: [ ^ Dictionary new ].
	
	^ { case result message -> 1 } asDictionary
]
