Class {
	#name : 'UmeFeedbackGuide',
	#superclass : 'Object',
	#instVars : [
		'evaluator'
	],
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'accessing' }
UmeFeedbackGuide >> category: value [
	
	^ self lnCategory: value
]

{ #category : 'accessing' }
UmeFeedbackGuide >> evaluator: anEvaluator [

	evaluator := anEvaluator
]

{ #category : 'accessing' }
UmeFeedbackGuide >> lnCategory: value [

	value isZero ifTrue: [ ^ 0 ].
	
	^ value ln rounded
]

{ #category : 'initialization' }
UmeFeedbackGuide >> setBase: base [

	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
UmeFeedbackGuide >> tableOfValue [

	self subclassResponsibility 
]

{ #category : 'accessing' }
UmeFeedbackGuide >> values: case [

	self subclassResponsibility 
]
