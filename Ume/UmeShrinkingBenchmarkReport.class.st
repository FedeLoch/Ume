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

	results at: shrinkerClass put: result
]

{ #category : 'adding' }
UmeShrinkingBenchmarkReport >> initialize [ 
	
	super initialize.
	results := Dictionary new.
]
