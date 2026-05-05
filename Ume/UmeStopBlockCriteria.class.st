Class {
	#name : 'UmeStopBlockCriteria',
	#superclass : 'UmeStopCriteria',
	#instVars : [
		'block',
		'step'
	],
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'accessing' }
UmeStopBlockCriteria >> block: aBlock [

	block := aBlock 
]

{ #category : 'asserting' }
UmeStopBlockCriteria >> computeProgressFor: tests since: time [
	
	^ (tests size / 10000) min: 1.0
]

{ #category : 'asserting' }
UmeStopBlockCriteria >> computeProgressFor: tests since: time for: iteration [
	
	^ (iteration / 10000) min: 1.0
]

{ #category : 'initialization' }
UmeStopBlockCriteria >> initialize [ 

	step := 0. 
]

{ #category : 'asserting' }
UmeStopBlockCriteria >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	^ block value: currentTests value: aTime value: aCoverage 
]
