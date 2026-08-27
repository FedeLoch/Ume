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
		'RSGridLayout
RSPieSlice
576->031 . 107->370 . 056->551'
		'RSTreeLayout
RSLabel
465->150 . 952->600'
		'RSSugiyamaLayout
RSPieSlice
369->154'
		'RSSugiyamaLayout
RSBox
679->886 . 333->677'
		'RSForceBasedLayout
RSEllipse
976->801 . 770->260'
		'RSForceBasedLayout
RSCircle
441->226 . 511->547 . 651->483 . 680->662 . 978->764'
		'RSRectangleForceLayout
RSPolygon
003->652 . 920->524'
		'RSRectangleForceLayout
RSCircle
721->152 . 184->235'
		'RSSugiyamaLayout
RSBox
305->726 . 886->543 . 890->980 . 963->305 . 426->636'
		'RSSugiyamaLayout
RSBox
686->688 . 674->467 . 129->045 . 045->179'
		'RSSugiyamaLayout
RSBox
688->688 . 674->467 . 129->045 . 045->179'
		'RSSugiyamaLayout
RSBox
688->688 . 674->467 . 129->045 . 674->756'
		'RSForceBasedLayout
RSPieSlice
231->247 . 761->129 . 767->988'
	) collect: [ :regex | ShrinkerTest input: regex oracle: oracle ]
]
