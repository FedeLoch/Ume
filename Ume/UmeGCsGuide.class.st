Class {
	#name : 'UmeGCsGuide',
	#superclass : 'UmeFeedbackGuide',
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'as yet unclassified' }
UmeGCsGuide >> tableOfValue [

	^ evaluator gcTable
]

{ #category : 'accessing' }
UmeGCsGuide >> values: case [

	^ case result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ {
		'gcs' -> (self category: case result profilingResult gcs)
	} asDictionary ]
]
