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

	| plt p |
	plt := RSCompositeChart new.
	
	results do: [ :data | 
		p := RSLinePlot new x: ( 1 to: data size ) y: ( self collectResult: data for: section ).
		plt add: p
		].

	plt xlabel: 'test number';
	ylabel: section;
	title: section, 'Benchmark';
	build.

	^ plt
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> collectResult: result for: section [

	^ result collect: [ :r | r at: section ]
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
