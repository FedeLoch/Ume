Class {
	#name : 'UmeShrinkingAExprBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'initialization' }
UmeShrinkingAExprBenchmark >> initialize [ 

	super initialize.
	grammar := AritExpressionGrammar new.
	tests := {
		ShrinkerTest new: 'input' error: 'error?'
	}.
]
