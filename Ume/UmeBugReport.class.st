Class {
	#name : 'UmeBugReport',
	#superclass : 'Object',
	#instVars : [
		'type',
		'test',
		'metric',
		'suspectedMethods',
		'suspiciousnessScores',
		'stackTrace',
		'errorMessage',
		'executedMethods',
		'uncoveredMethods'
	],
	#category : 'Ume-Localization',
	#package : 'Ume',
	#tag : 'Localization'
}

{ #category : 'instance creation' }
UmeBugReport class >> for: aTest type: aSymbol [
	^ self new
		test: aTest;
		type: aSymbol;
		yourself
]

{ #category : 'accessing' }
UmeBugReport >> errorMessage [

	^ errorMessage
]

{ #category : 'accessing' }
UmeBugReport >> errorMessage: aString [

	errorMessage := aString
]

{ #category : 'accessing' }
UmeBugReport >> executedMethods [

	^ executedMethods
]

{ #category : 'accessing' }
UmeBugReport >> executedMethods: aSet [

	executedMethods := aSet
]

{ #category : 'accessing' }
UmeBugReport >> metric [

	^ metric
]

{ #category : 'accessing' }
UmeBugReport >> metric: aSymbol [

	metric := aSymbol
]

{ #category : 'printing' }
UmeBugReport >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' type: ';
		nextPutAll: type asString.
	metric ifNotNil: [ aStream nextPutAll: ' metric: '; nextPutAll: metric asString ].
	aStream nextPutAll: ' test: '; print: test name.
	suspectedMethods ifNotNil: [ :methods |
		aStream nextPutAll: ' top suspect: '.
		methods ifEmpty: [ aStream nextPutAll: '(none)' ] ifNotEmpty: [ aStream print: methods first ] ].
	errorMessage ifNotNil: [ aStream nextPutAll: ' error: '; nextPutAll: errorMessage ]
]

{ #category : 'accessing' }
UmeBugReport >> stackTrace [

	^ stackTrace
]

{ #category : 'accessing' }
UmeBugReport >> stackTrace: aCollection [

	stackTrace := aCollection
]

{ #category : 'accessing' }
UmeBugReport >> suspectedMethods [

	^ suspectedMethods
]

{ #category : 'accessing' }
UmeBugReport >> suspectedMethods: anOrderedCollection [

	suspectedMethods := anOrderedCollection
]

{ #category : 'accessing' }
UmeBugReport >> suspiciousnessScores [

	^ suspiciousnessScores
]

{ #category : 'accessing' }
UmeBugReport >> suspiciousnessScores: aDictionary [

	suspiciousnessScores := aDictionary
]

{ #category : 'accessing' }
UmeBugReport >> test [

	^ test
]

{ #category : 'accessing' }
UmeBugReport >> test: aUmeTest [

	test := aUmeTest
]

{ #category : 'accessing' }
UmeBugReport >> type [

	^ type
]

{ #category : 'accessing' }
UmeBugReport >> type: aSymbol [

	type := aSymbol
]

{ #category : 'accessing' }
UmeBugReport >> uncoveredMethods [

	^ uncoveredMethods
]

{ #category : 'accessing' }
UmeBugReport >> uncoveredMethods: aSet [

	uncoveredMethods := aSet
]
