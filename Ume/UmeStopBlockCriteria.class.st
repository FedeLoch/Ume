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
	"| progression|
	progression := 100 - (self rest) + (self rest/ 2).
	rest := (100 - progression ). 
	
	
	^ progression min: 100."
	
	|limit|
	limit := 10000.
	^ (tests size / limit) min: 1.0
]

{ #category : 'initialization' }
UmeStopBlockCriteria >> initialize [ 

	step := 0. 
]

{ #category : 'asserting' }
UmeStopBlockCriteria >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	^ block value: currentTests value: aTime value: aCoverage 
]
