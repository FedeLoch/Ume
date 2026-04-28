Class {
	#name : 'UmeStopCriteria',
	#superclass : 'Object',
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'asserting' }
UmeStopCriteria >> computeProgressFor: tests since: time [

	^ self subclassResponsibility 
]

{ #category : 'asserting' }
UmeStopCriteria >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	^ self subclassResponsibility 
]
