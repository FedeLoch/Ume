Class {
	#name : 'UmeExecutionTimeGuide',
	#superclass : 'UmeFeedbackGuide',
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'accessing' }
UmeExecutionTimeGuide >> category: value [

	^ value
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeGuide >> tableOfValue [

	^ evaluator performanceTable
]

{ #category : 'accessing' }
UmeExecutionTimeGuide >> values: case [

	^ case result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ {
		'executionTime' -> (self category: case result profilingResult executionTime)
	} asDictionary ]
]
