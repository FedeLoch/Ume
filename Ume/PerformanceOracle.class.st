Class {
	#name : 'PerformanceOracle',
	#superclass : 'UmeInputOracle',
	#instVars : [
		'threshold',
		'evalBlock'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
PerformanceOracle >> accepts: input from: baseline [

	^ [ (self evalInput: input) >= (baseline * threshold) ] on: Error do: [ :e | ^ false ]
]

{ #category : 'as yet unclassified' }
PerformanceOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'as yet unclassified' }
PerformanceOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
PerformanceOracle >> evalInput: regex [

	^ (1 timesCollect: [
		[ evalBlock value: regex ] microsecondsToRun
	]) average
]

{ #category : 'initialization' }
PerformanceOracle >> initialize [ 

	threshold := 0.95
]

{ #category : 'initialization' }
PerformanceOracle >> threshold [

	^ threshold 
]

{ #category : 'initialization' }
PerformanceOracle >> threshold: aThreshold [

	threshold := aThreshold 
]

{ #category : 'initialization' }
PerformanceOracle >> valueBound: bound [

	^ bound
]
