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
		1 halt.
		'gcs' -> (self category: case result profilingResult numberOfGCs)
	} asDictionary ]
]
