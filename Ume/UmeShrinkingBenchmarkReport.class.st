Class {
	#name : 'UmeShrinkingBenchmarkReport',
	#superclass : 'Object',
	#instVars : [
		'results'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'adding' }
UmeShrinkingBenchmarkReport >> add: result for: shrinkerClass [

	results at: shrinkerClass name put: result
]

{ #category : 'adding' }
UmeShrinkingBenchmarkReport >> initialize [ 
	
	super initialize.
	results := Dictionary new.
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> saveAsFile: fileName [

	(fileName asFileReference) writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: results)
	] 
]
