Class {
	#name : 'UmeReductionShrinkerTest',
	#superclass : 'TestCase',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeReductionShrinkerTest >> oracleByBlock: block [

	^ UmeBooleanInputOracle from: block
]
