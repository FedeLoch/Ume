Class {
	#name : 'UmeShrinkingRegexBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'initialization' }
UmeShrinkingRegexBenchmark >> initialize [ 

	super initialize.
	grammar := GncRegexGrammar new.
	tests := {
		ShrinkerTest input: 'ac?ab?ab?b?aa.?aaab?c?a(c)?ac?aaab?a?a' oracle: PerformanceOracle new.
		ShrinkerTest input: 'ac?ab?ab|.b?aa.?aaab?c?a(ca)?ac?aaab?a?a' oracle: PerformanceOracle new.
		
	}
]
