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

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> asPlots: section [ 

	| plt p x y |
	plt := RSCompositeChart new.
	
	results do: [ :res | 
		x := 1 to: res size. 
		y := self collectResult: res for: section.
		p := RSLinePlot new x: x y: y.
		plt add: p
		].

	plt xlabel: 'test number'.
	plt ylabel: section.
	plt title: section, ' benchmark'."
	plt verticalTick integer numberOfTicks: 1."
	
	plt build.
	^ plt
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> collectResult: result for: section [

	| res |
	res := OrderedCollection new. 
	result do: [ :r | res add: (r at: section) ].
	^ res. 
	
]

{ #category : 'adding' }
UmeShrinkingBenchmarkReport >> initialize [ 
	
	super initialize.
	results := Dictionary new.
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> plotFailedReductions [

	^ (self asPlots: 'failedReductions') open
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> plotInputReduction [

	^ (self asPlots: '%inputReduction') open
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> plotNeededIterations [

	^ (self asPlots: 'neededReductions') open
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> plotProblemPreservation [

	^ (self asPlots: '%problemPreservation') open
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> plotTotalTime [

	^ (self asPlots: 'totalTime') open
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> saveAsFile: fileName [

	(fileName asFileReference) writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: results)
	] 
]
