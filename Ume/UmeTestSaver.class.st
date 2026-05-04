Class {
	#name : 'UmeTestSaver',
	#superclass : 'Object',
	#instVars : [
		'tests'
	],
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'as yet unclassified' }
UmeTestSaver >> saveTest: aTest [

	^ self subclassResponsibility 
]
