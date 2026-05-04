Class {
	#name : 'UmeAllTestsSaver',
	#superclass : 'UmeTestSaver',
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'as yet unclassified' }
UmeAllTestsSaver >> saveTest: aTest [

	 aTest feedback improvement > 0 ifTrue: [ tests add: aTest ]
]
