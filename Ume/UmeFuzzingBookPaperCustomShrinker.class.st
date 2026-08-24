Class {
	#name : 'UmeFuzzingBookPaperCustomShrinker',
	#superclass : 'UmeDDminFuzzingBookShrinker',
	#instVars : [
		'caller'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'accessing' }
UmeFuzzingBookPaperCustomShrinker >> caller: aCaller [

	caller := aCaller.
]

{ #category : 'shrinking' }
UmeFuzzingBookPaperCustomShrinker >> failedMinimization [

	super failedMinimization.
	caller failedMinimization
]

{ #category : 'shrinking' }
UmeFuzzingBookPaperCustomShrinker >> minimizationDone [

	super minimizationDone.
	caller minimizationDone
]
