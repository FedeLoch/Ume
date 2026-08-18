Class {
	#name : 'UmeExecutionTimeOracle',
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
UmeExecutionTimeOracle >> accepts: input from: baseline [

	^ [ (self evalInput: input) >= (baseline * threshold) ] on: Error do: [ :e | ^ false ]
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalInput: regex [

	^ (1 timesCollect: [
		[ evalBlock value: regex ] microsecondsToRun
	]) average
]

{ #category : 'initialization' }
UmeExecutionTimeOracle >> initialize [ 

	threshold := 0.95
]

{ #category : 'initialization' }
UmeExecutionTimeOracle >> threshold [

	^ threshold 
]

{ #category : 'initialization' }
UmeExecutionTimeOracle >> threshold: aThreshold [

	threshold := aThreshold 
]

{ #category : 'initialization' }
UmeExecutionTimeOracle >> valueBound: bound [

	^ bound
]
