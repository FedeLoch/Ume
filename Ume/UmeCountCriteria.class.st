Class {
	#name : 'UmeCountCriteria',
	#superclass : 'UmeStopCriteria',
	#instVars : [
		'times'
	],
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'asserting' }
UmeCountCriteria >> computeProgressFor: tests since: time [

	^ tests size / times 
]

{ #category : 'asserting' }
UmeCountCriteria >> computeProgressFor: tests since: time for: iteration [

	^ iteration / times 
]

{ #category : 'asserting' }
UmeCountCriteria >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	^ currentTests < times
]

{ #category : 'as yet unclassified' }
UmeCountCriteria >> times: aCount [

	times := aCount
]
