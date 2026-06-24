Class {
	#name : 'UmeShrinkingSVGBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'initialization' }
UmeShrinkingSVGBenchmark >> initialize [

	| oracle |
	
	super initialize.
	grammar := SvgPathGrammar new.
	oracle := PerformanceOracle new evalBlock: [ :path | SVGRunner run: path ].
	
	tests := #() collect: [ :svg |
		ShrinkerTest input: svg oracle: oracle
	]
]
