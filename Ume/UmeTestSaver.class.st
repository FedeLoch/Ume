Class {
	#name : 'UmeTestSaver',
	#superclass : 'Object',
	#instVars : [
		'tests'
	],
	#classInstVars : [
		'testsCollection'
	],
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'as yet unclassified' }
UmeTestSaver >> saveTest: aTest [

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
UmeTestSaver >> tests [

	^ tests
]

{ #category : 'accessing' }
UmeTestSaver >> tests: aTestsCollection [

	tests := aTestsCollection 
]
