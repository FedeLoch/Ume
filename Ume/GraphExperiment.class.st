Class {
	#name : 'GraphExperiment',
	#superclass : 'GrammarBasePathologicalBugMutatorPaperExperiment',
	#category : 'Ume-PerfUme Experimentation',
	#package : 'Ume',
	#tag : 'PerfUme Experimentation'
}

{ #category : 'running' }
GraphExperiment >> baseSeed [

	^ 'RSSugiyamaLayout
RSBox
552->882 . 583->865'
]

{ #category : 'running' }
GraphExperiment >> complexSeed [

	^ 'RSHorizontalDominanceTreeLayout
RSPolygon
534->657 . 768->178'
]

{ #category : 'running' }
GraphExperiment >> maxInputSize [

	^ 1000
]

{ #category : 'running' }
GraphExperiment >> methodsToInstrument [

	^ RSLineBuilder package methods, RSClusterRadialTreeLayout package methods
]

{ #category : 'running' }
GraphExperiment >> name [

	^ 'PharoGraphs'
]

{ #category : 'running' }
GraphExperiment >> newGrammar [

	^ RoassalGraphGrammar new
]

{ #category : 'running' }
GraphExperiment >> schemaCorpusWith: mutators selector: selector seeds: nSeeds [

	| graphCodeGenerator |
	
	graphCodeGenerator := self corpusGenerator: mutators selector: selector seeds: nSeeds.

	^ UmeSchema new
		  receiverConstraint: (UmeConstantGenerator new value: UmeRoassalGrapher);
		  argumentConstraints: { graphCodeGenerator };
		  property: [ :regex :input :result | true ]
]

{ #category : 'running' }
GraphExperiment >> seeds: nSeeds [
	"Auto Generated but hardcoded to allow repetition"
	
	(nSeeds = 2) ifTrue: [ ^ { self baseSeed . self complexSeed } ].

	^ #( 'RSGridLayout
RSPieSlice
576->031 . 107->370 . 056->551' 'RSTreeLayout
RSLabel
465->150 . 952->600' 'RSCircleLayout
RSLabel
120->416' 'RSHorizontalVanDerPloegTreeLayout
RSCircle
862->741' 'RSCircleLayout
RSEllipse
034->354' 'RSCellLayout
RSPolygon
630->036' 'RSSugiyamaLayout
RSPieSlice
369->154' 'RSEquidistantCircleLayout
RSPieSlice
396->563 . 880->153 . 041->099' 'RSEquidistantCircleLayout
RSPieSlice
755->445' 'RSHorizontalDominanceTreeLayout
RSBox
661->396 . 850->470' 'RSCellLayout
RSPieSlice
680->061' 'RSSugiyamaLayout
RSBox
679->886 . 333->677' 'RSConditionalLayout
RSCircle
666->562' 'RSOvalLayout
RSCircle
202->555' 'RSRadialTreeLayout
RSLabel
902->043 . 281->322 . 975->330 . 131->648 . 585->654 . 236->643' 'RSSunburstExtentLayout
RSLabel
433->365' 'RSConditionalLayout
RSPolygon
608->195 . 403->262' 'RSHorizontalLineLayout
RSEllipse
160->103 . 324->038' 'RSRectanglePackLayout
RSEllipse
870->105 . 409->742 . 188->100' 'RSCircleLayout
RSPieSlice
676->710 . 354->512' 'RSVerticalCellLayout
RSPolygon
566->453 . 624->122 . 521->052 . 143->159' 'RSCellLayout
RSEllipse
609->287' 'RSVerticalCellLayout
RSLabel
353->784 . 186->568' 'RSCircularAroundAVertexLayout
RSEllipse
905->678 . 369->763 . 567->641 . 944->142' 'RSForceBasedLayout
RSEllipse
976->801 . 770->260' 'RSConditionalLayout
RSPolygon
069->488' 'RSClusterRadialTreeLayout
RSEllipse
388->160' 'RSHorizontalVanDerPloegTreeLayout
RSLabel
082->521' 'RSCircularAroundAVertexLayout
RSCircle
537->041' 'RSCircularAroundAVertexLayout
RSPolygon
445->907' 'RSHorizontalFlowLayout
RSCircle
150->733' 'RSSugiyamaLayout
RSPieSlice
508->235' 'RSSunburstConstantWidthLayout
RSBitmap
629->396' 'RSSunburstExtentLayout
RSBox
693->978 . 811->790 . 325->151 . 006->754' 'RSSimpleForceBasedLayout
RSBox
342->486 . 480->979' 'RSSunburstExtentLayout
RSPieSlice
220->710' 'RSHorizontalVanDerPloegTreeLayout
RSPieSlice
584->749 . 184->556' 'RSConditionalLayout
RSCircle
099->313' 'RSForceBasedLayout
RSCircle
441->226 . 511->547 . 651->483 . 680->662 . 978->764' 'RSRadialTreeLayout
RSCircle
429->892 . 578->577' 'RSConditionalLayout
RSBox
274->344 . 755->882 . 900->730 . 936->398' 'RSRectanglePackLayout
RSCircle
548->089 . 167->333 . 598->743 . 767->665' 'RSClusterRadialTreeLayout
RSPolygon
036->796' 'RSSimpleForceBasedLayout
RSEllipse
622->598' 'RSClusterRadialTreeLayout
RSBox
170->322 . 809->288 . 137->500 . 836->777 . 001->328 . 331->075 . 282->445 . 542->517 . 534->201 . 628->525'
	     'RSSimpleForceBasedLayout
RSBitmap
487->389 . 697->668 . 301->047' 'RSCellLayout
RSPolygon
390->861' 'RSHorizontalLineLayout
RSBox
407->697 . 075->007 . 965->711' 'RSCircleLayout
RSPieSlice
995->408 . 793->820' 'RSHorizontalFlowLayout
RSEllipse
877->109' 'RSRadialTreeLayout
RSLabel
714->802' 'RSFlowLayout
RSEllipse
994->919' 'RSCircleLayout
RSBox
420->125' 'RSHorizontalLineLayout
RSBitmap
751->726' 'RSAngleLineLayout
RSBox
492->159' 'RSHorizontalTreeLayout
RSBox
154->955 . 671->431 . 012->044 . 080->023' 'RSSimpleForceBasedLayout
RSBitmap
540->112' 'RSHorizontalLineLayout
RSBitmap
413->147 . 949->115 . 105->604' 'RSTreeLayout
RSLabel
783->886' 'RSClusterRadialTreeLayout
RSPolygon
371->693 . 498->135 . 031->317' 'RSSunburstConstantWidthLayout
RSPolygon
903->777 . 876->248 . 697->919 . 327->921' 'RSRectangleForceLayout
RSPolygon
003->652 . 920->524' 'RSHorizontalLineLayout
RSBox
676->125' 'RSClusteringLayout
RSPieSlice
202->383 . 976->980' 'RSHorizontalVanDerPloegTreeLayout
RSEllipse
695->715' 'RSHorizontalTreeLayout
RSBitmap
800->849 . 452->206 . 017->300' 'RSDominanceTreeLayout
RSEllipse
140->420 . 621->141' 'RSCellLayout
RSCircle
499->381 . 309->677' 'RSForceBasedLayout
RSLabel
493->455 . 072->157 . 283->881 . 346->505' 'RSClusterRadialTreeLayout
RSEllipse
848->417 . 699->492' 'RSAngleLineLayout
RSPieSlice
754->341 . 736->460' 'RSDominanceTreeLayout
RSEllipse
987->328' 'RSDominanceTreeLayout
RSCircle
491->754 . 339->568' 'RSRectangleForceLayout
RSCircle
721->152 . 184->235' 'RSGridLayout
RSCircle
934->543 . 598->763' 'RSVerticalCellLayout
RSPieSlice
575->381 . 208->190 . 387->152' 'RSWeightedCircleLayout
RSLabel
154->803 . 251->070 . 458->084 . 140->866 . 329->486 . 846->967 . 451->132' 'RSCircularAroundAVertexLayout
RSLabel
842->876' 'RSSunburstConstantWidthLayout
RSPieSlice
484->031 . 226->316' 'RSVanDerPloegTreeLayout
RSPolygon
742->773' 'RSHorizontalVanDerPloegTreeLayout
RSBox
974->790' 'RSHorizontalTreeLayout
RSBitmap
494->339' 'RSConditionalLayout
RSPolygon
706->903 . 506->362 . 158->634 . 753->606' 'RSRectanglePackLayout
RSPolygon
495->734 . 542->124 . 704->666 . 099->138' 'RSFlowLayout
RSLabel
959->230 . 625->578' 'RSVanDerPloegTreeLayout
RSLabel
796->168' 'RSForceBasedLayout
RSEllipse
376->994 . 385->308' 'RSVerticalCellLayout
RSPieSlice
209->612' 'RSRectangleForceLayout
RSPolygon
740->204 . 794->029' 'RSVanDerPloegTreeLayout
RSLabel
886->612' 'RSOvalLayout
RSPolygon
523->125' 'RSRectangleForceLayout
RSEllipse
206->987' 'RSHorizontalVanDerPloegTreeLayout
RSBox
950->752' 'RSRectanglePackLayout
RSLabel
162->469 . 462->049' 'RSRadialTreeLayout
RSBox
633->195 . 899->747' 'RSFlowLayout
RSBitmap
801->359' 'RSSimpleForceBasedLayout
RSBitmap
752->431' 'RSDominanceTreeLayout
RSLabel
322->948' 'RSTreeLayout
RSLabel
964->036' 'RSRectanglePackLayout
RSPieSlice
678->557' )
]

{ #category : 'running' }
GraphExperiment >> targetMethod [

	^ UmeRoassalGrapher class >> #run:
]

{ #category : 'running' }
GraphExperiment >> weightedGrammarSchema [

	| graphCodeGenerator |
	
	graphCodeGenerator := UmeGrammarGenerator new grammar: self newGrammar; maxSize: self maxInputSize.

	^ UmeSchema new
		receiverConstraint: (UmeConstantGenerator new value: UmeRoassalGrapher);
		argumentConstraints: { graphCodeGenerator };
		property: [ :regex :input :result | true ].
]
