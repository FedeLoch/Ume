Class {
	#name : 'UmeDDCustomShrinker',
	#superclass : 'UmeDDShrinker',
	#instVars : [
		'caller'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'accessing' }
UmeDDCustomShrinker >> caller: aCaller [

	caller := aCaller.
]

{ #category : 'shrinking' }
UmeDDCustomShrinker >> failedMinimization [

	super failedMinimization.
	caller failedMinimization
]

{ #category : 'shrinking' }
UmeDDCustomShrinker >> minimizationDone [

	super minimizationDone.
	caller minimizationDone
]
