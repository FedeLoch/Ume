Class {
	#name : 'UmeDDminPaperCustomShrinker',
	#superclass : 'UmeDDminPaperShrinker',
	#instVars : [
		'caller'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'accessing' }
UmeDDminPaperCustomShrinker >> caller: aCaller [

	caller := aCaller.
]

{ #category : 'shrinking' }
UmeDDminPaperCustomShrinker >> failedMinimization [

	super failedMinimization.
	caller failedMinimization
]

{ #category : 'shrinking' }
UmeDDminPaperCustomShrinker >> minimizationDone [

	super minimizationDone.
	caller minimizationDone
]
