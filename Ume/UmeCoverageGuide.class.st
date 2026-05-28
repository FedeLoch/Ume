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
UmeCoverageGuide >> coverageGuidingTable: result [

"	^ result profilingResult coverage"
	^ {
		'methods' -> result coverageResult methods size.
		'nodes' -> result coverageResult nodes size.
		'percentage' -> result coverageResult percentage
	} asDictionary
]

{ #category : 'as yet unclassified' }
UmeCoverageGuide >> tableOfValue [

	^ evaluator coverageTable
]

{ #category : 'accessing' }
UmeCoverageGuide >> values: case [

	^ case result profilingResult ifNil: [ Dictionary new ] ifNotNil: [
		self coverageGuidingTable: case result
	]
]
