Class {
	#name : 'UmeExecutionTimeGuide',
	#superclass : 'UmeFeedbackGuide',
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'accessing' }
UmeExecutionTimeGuide >> category: value [
	"Same logarithmic buckets as the methods calls guide, so timing noise is not rewarded as an improvement"

	value <= 0 ifTrue: [ ^ 0 ].
	(value = 1) ifTrue: [ ^ 1 ].

	^ self lnCategory: value
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
