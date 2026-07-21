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

	| plt p colors |
	plt := RSChart new.
	colors := { Color blue . Color red . Color green . Color orange . Color purple . Color cyan }.
	
	results doWithIndex: [ :data :index | 
		p := RSLinePlot new x: ( 1 to: data size ) y: ( self collectResult: data for: section ).
		p color: (colors atWrap: index).
		p marker: (RSEllipse new size: 4; color: (colors atWrap: index)).
		plt add: p
	].

	plt xlabel: 'test number';
	ylabel: section;
	title: section, ' benchmark';
	build.

	self buildLegend: plt with: section palette: colors. 

	^ plt canvas 
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> buildLegend: plot with: section palette: colors [
	
	| legend |
	
	legend := RSLegend new.
	legend container: plot canvas;
	title: 'Legend'.
	
	results doWithIndex: [ :data :index |
		| name |
		name := (results keyAtValue: data) asString.
		legend text: name withBoxColor: (colors atWrap: index)
	].
	
   legend legendDo: [ :l | 
        l withBorder; padding: 10 ].
    legend location right; middle; offset: 10@0.
    legend build.
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> collectResult: result for: section [

	( section = 'totalTime' ) ifTrue: [ 
		^ result collect: [ :r | (r at: section) asMicroseconds ]  ].
	
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

	^ (self asPlots: 'totalTime' ) open
]

{ #category : 'as yet unclassified' }
UmeShrinkingBenchmarkReport >> saveAsFile: fileName [

	(fileName asFileReference) writeStreamDo: [ :stream |
		stream nextPutAll: (NeoJSONWriter toStringPretty: results)
	] 
]
