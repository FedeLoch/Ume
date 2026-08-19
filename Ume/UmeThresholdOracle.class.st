Class {
	#name : 'UmeThresholdOracle',
	#superclass : 'UmeInputOracle',
	#instVars : [
		'threshold'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeThresholdOracle >> accepts: input from: baseline [

	^ [ (self evalInput: input) >= (baseline * threshold) ] on: Error do: [ :e | ^ false ]
]

{ #category : 'as yet unclassified' }
UmeThresholdOracle >> evalInput: input [

	self subclassResponsibility 
]

{ #category : 'initialization' }
UmeThresholdOracle >> initialize [ 

	threshold := 0.95
]

{ #category : 'initialization' }
UmeThresholdOracle >> threshold [

	^ threshold
]

{ #category : 'initialization' }
UmeThresholdOracle >> threshold: aThreshold [

	threshold := aThreshold 
]

{ #category : 'initialization' }
UmeThresholdOracle >> valueBound: bound [

	^ bound
]
