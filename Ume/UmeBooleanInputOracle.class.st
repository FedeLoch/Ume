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

{ #category : 'as yet unclassified' }
UmeBooleanInputOracle >> accepts: input from: _ [
	
	^ block value: input
]

{ #category : 'accessing' }
UmeBooleanInputOracle >> block: booleanBlock [

	block := booleanBlock
]

{ #category : 'as yet unclassified' }
UmeBooleanInputOracle >> valueBound: bound [

	^ bound ifTrue: [ 100 ] ifFalse: [ 0 ]

]
