Class {
	#name : 'UmeShrinkingGraphCoverageBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking Benchmarks',
	#package : 'Ume',
	#tag : 'Shrinking Benchmarks'
}

{ #category : 'initialization' }
UmeShrinkingGraphCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := RoassalGraphGrammar new.
	oracle := UmeCoverageOracle new
		          methodsToInstrument: RSLineBuilder package methods, RSClusterRadialTreeLayout package methods;
		          evalBlock: [ :input | UmeRoassalGrapher run: input ].

	tests := #(
		'RSGridLayout\rRSPieSlice\r576->031 . 107->370 . 056->551'
		'RSTreeLayout\rRSLabel\r465->150 . 952->600'
		'RSSugiyamaLayout\rRSPieSlice\r369->154'
		'RSSugiyamaLayout\rRSBox\r679->886 . 333->677'
		'RSForceBasedLayout\rRSEllipse\r976->801 . 770->260'
		'RSForceBasedLayout\rRSCircle\r441->226 . 511->547 . 651->483 . 680->662 . 978->764'
		'RSRectangleForceLayout\rRSPolygon\r003->652 . 920->524'
		'RSRectangleForceLayout\rRSCircle\r721->152 . 184->235'
		'RSSugiyamaLayout\rRSBox\r305->726 . 886->543 . 890->980 . 963->305 . 426->636'
		'RSSugiyamaLayout\rRSBox\r686->688 . 674->467 . 129->045 . 045->179'
		'RSSugiyamaLayout\rRSBox\r688->688 . 674->467 . 129->045 . 045->179'
		'RSSugiyamaLayout\rRSBox\r688->688 . 674->467 . 129->045 . 674->756'
		'RSForceBasedLayout\rRSPieSlice\r231->247 . 761->129 . 767->988'
	) collect: [ :regex | ShrinkerTest input: regex oracle: oracle ]
]
