Class {
	#name : 'UmeInputOracle',
	#superclass : 'Object',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeInputOracle >> accepts: bound from: base [

	"It returns true if the input triggers the bug"
	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeInputOracle >> evalInput: input [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeInputOracle >> percentageProblemPreservation: upperBound given: currentBound [

	| baseline current |
	
	baseline := self valueBound: upperBound.
	current := self valueBound: currentBound.
	
	(baseline = 0) ifTrue: [ ^ 0 ].
	
	^ ((current * 100) / baseline) asFloat
]

{ #category : 'as yet unclassified' }
UmeInputOracle >> valueBound: bound [

	self subclassResponsibility 
]
