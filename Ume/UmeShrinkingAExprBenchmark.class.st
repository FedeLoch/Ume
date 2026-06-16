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
		"ShrinkerTest input: '1+(2*3)/0' oracle: DivideZeroOracle new."
		ShrinkerTest input: '((8500/(208000*80))+(165468468)*(423-12)*(999/(12+88)))/(((145*4)-580)*3)+((456)*12)-(89/(45+(12*8)))+(77*14)' oracle: DivideZeroOracle new.
	}
]

{ #category : 'initialization' }
UmeShrinkingAExprBenchmark >> oracleByBlock: block [

	^ UmeBooleanInputOracle from: block
]
