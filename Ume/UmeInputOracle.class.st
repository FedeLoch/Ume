Class {
	#name : 'UmeInputOracle',
	#superclass : 'Object',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeInputOracle >> isAccepted: input [
	"It returns true if the input triggers the bug"
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
UmeInputOracle >> problemPresence: bound [

	self subclassResponsibility 
]
