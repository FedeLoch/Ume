Class {
	#name : 'UmeShrinkingJSONCoverageBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking Benchmarks',
	#package : 'Ume',
	#tag : 'Shrinking Benchmarks'
}

{ #category : 'initialization' }
UmeShrinkingJSONCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := JSONGrammar new.
	oracle := UmeCoverageOracle new
		          methodsToInstrument: NeoJSONReader package methods;
		          evalBlock: [ :input | NeoJSONReader fromString: input ].

	tests := #(
		'{}'
		'{\"n\":true,\"n\":[],\"x\":6}'
		'{\"s\":true,\"n\":[\"v\"],\"x\":6}'
		'{\"s\":true,\"n\":[[false]],\"x\":6}'
		'{\"s\":true,\"n\":[[false]],\"y\":[{\"t\":null},5]}'
		'{\"s\":true,\"n\":[[false]],\"y\":[{\"th\":null},8e5]}'
		'{\"s\":true,\"n\":[[false],5],\"}y\":[{\"th\":null},8e5]}'
	) collect: [ :input | ShrinkerTest input: input oracle: oracle ]
]
