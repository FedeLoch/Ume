Class {
	#name : 'DivideZeroOracle',
	#superclass : 'UmeInputOracle',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
DivideZeroOracle >> accepts: input from: _ [ 

	[
		OpalCompiler new
			source: input;
			evaluate ]
		on: Error
		do: [ :error | ^ error isKindOf: ZeroDivide ].

	^ false
]

{ #category : 'as yet unclassified' }
DivideZeroOracle >> evalInput: input [

	^ self accepts: input from: nil
]

{ #category : 'as yet unclassified' }
DivideZeroOracle >> valueBound: bound [

	^ bound ifTrue: [ 100 ] ifFalse: [ 0 ]
]
