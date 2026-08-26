Class {
	#name : 'UmeCoverageOracle',
	#superclass : 'UmeThresholdOracle',
	#instVars : [
		'evalBlock',
		'methodsToInstrument',
		'collector'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeCoverageOracle >> accepts: input from: baseline [

	^ (self evalInput: input) values = baseline values
]

{ #category : 'accessing' }
UmeCoverageOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'accessing' }
UmeCoverageOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
UmeCoverageOracle >> evalInput: input [

	| result |
	" return the coverage table "
	result := collector runOn: [ evalBlock value: input ].
	^ {
		  ('percetange' -> result percentage).
		  ('nodes' -> result nodes size).
		  ( 'methods' -> result methods size)
	} asDictionary 
]

{ #category : 'initialization' }
UmeCoverageOracle >> initialize [ 

	super initialize.
	collector := C2CoverageCollector new methods: {}.
	threshold := 1.
]

{ #category : 'accessing' }
UmeCoverageOracle >> methodsToInstrument [ 

	^ methodsToInstrument 
]

{ #category : 'accessing' }
UmeCoverageOracle >> methodsToInstrument: methods [

	methodsToInstrument := methods.
	collector methods: methodsToInstrument.
	
]

{ #category : 'shrinking' }
UmeCoverageOracle >> percentageProblemPreservation: upperBound given: currentBound [

	^ 100
]
