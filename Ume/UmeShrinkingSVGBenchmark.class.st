Class {
	#name : 'UmeShrinkingSVGBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'initialization' }
UmeShrinkingSVGBenchmark >> initialize [

	super initialize.
	grammar := GncRegexGrammar new.
	tests := { } collect: [ :svg |
		ShrinkerTest input: svg oracle: PerformanceOracle new
	]
]
