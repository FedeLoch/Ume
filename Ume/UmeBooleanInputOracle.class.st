Class {
	#name : 'UmeBooleanInputOracle',
	#superclass : 'UmeInputOracle',
	#instVars : [
		'block'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'instance creation' }
UmeBooleanInputOracle class >> from: booleanBlock [

	^ self new block: booleanBlock

	
	
]

{ #category : 'accessing' }
UmeBooleanInputOracle >> block: booleanBlock [

	block := booleanBlock
]

{ #category : 'as yet unclassified' }
UmeBooleanInputOracle >> isAccepted: input [
	
	^ block value: input
]

{ #category : 'as yet unclassified' }
UmeBooleanInputOracle >> problemPresence: bound [

	^ bound ifFalse: [ 100 ] ifTrue: [ 0 ]

]
