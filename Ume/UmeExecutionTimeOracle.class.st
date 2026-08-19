Class {
	#name : 'UmeExecutionTimeOracle',
	#superclass : 'UmeThresholdOracle',
	#instVars : [
		'evalBlock'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
UmeExecutionTimeOracle >> evalInput: input [

	^ (1 timesCollect: [
		[ evalBlock value: input ] microsecondsToRun
	]) average
]
