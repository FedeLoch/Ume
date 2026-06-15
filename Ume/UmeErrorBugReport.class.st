Class {
	#name : 'UmeErrorBugReport',
	#superclass : 'UmeBugReport',
	#instVars : [
		'stackTrace',
		'errorMessage'
	],
	#category : 'Ume-Localization',
	#package : 'Ume',
	#tag : 'Localization'
}

{ #category : 'as yet unclassified' }
UmeErrorBugReport >> bugId [

	^ errorMessage
]

{ #category : 'accessing' }
UmeErrorBugReport >> errorMessage [

	^ errorMessage
]

{ #category : 'accessing' }
UmeErrorBugReport >> errorMessage: message [

	errorMessage := message
]

{ #category : 'accessing' }
UmeErrorBugReport >> stackTrace [

	^ stackTrace
]

{ #category : 'accessing' }
UmeErrorBugReport >> stackTrace: trace [

	stackTrace := trace
]

{ #category : 'accessing' }
UmeErrorBugReport >> type [

	^ #errorBug
]
