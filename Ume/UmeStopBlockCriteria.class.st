Class {
	#name : 'UmeStopBlockCriteria',
	#superclass : 'UmeStopCriteria',
	#instVars : [
		'block',
		'rest'
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
	
	| step |
	step := self rest * 0.1.
	rest := (self rest - step).
	^ (100 - self rest ) /100
	
	
]

{ #category : 'initialization' }
UmeStopBlockCriteria >> initialize [ 

	rest := 100. 
]

{ #category : 'accessing' }
UmeStopBlockCriteria >> rest [ 

	^ rest 
]

{ #category : 'accessing' }
UmeStopBlockCriteria >> rest: aRest [

	rest := aRest 
]

{ #category : 'asserting' }
UmeStopBlockCriteria >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	^ block value: currentTests value: aTime value: aCoverage 
]
