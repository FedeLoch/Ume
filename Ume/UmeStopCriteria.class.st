Class {
	#name : 'UmeStopCriteria',
	#superclass : 'Object',
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'asserting' }
UmeStopCriteria >> progressFor: tests since: time for: iteration [

	^ self subclassResponsibility 
]

{ #category : 'asserting' }
UmeStopCriteria >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	^ self subclassResponsibility 
]
