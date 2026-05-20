Class {
	#name : 'UmeCoverageGuide',
	#superclass : 'UmeFeedbackGuide',
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'accessing' }
UmeCoverageGuide >> category: value [
	"TODO: not sure"
	^ value
]

{ #category : 'as yet unclassified' }
UmeCoverageGuide >> tableOfValue [

	^ evaluator coverageTable
]

{ #category : 'accessing' }
UmeCoverageGuide >> values: case [

	^ case result profilingResult ifNil: [ Dictionary new ] ifNotNil: [
		case result profilingResult coverage collect: [ :value | self category: value ]
	]
]
