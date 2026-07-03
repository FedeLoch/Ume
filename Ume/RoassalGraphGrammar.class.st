Class {
	#name : 'RoassalGraphGrammar',
	#superclass : 'GncGrammar',
	#instVars : [
		'ntGraphConfig',
		'ntEdges',
		'ntShape',
		'ntLayout',
		'ntNode',
		'ntInt'
	],
	#category : 'Ume-Grammars',
	#package : 'Ume',
	#tag : 'Grammars'
}

{ #category : 'initialization' }
RoassalGraphGrammar >> defineGrammar [

	ntGraphConfig --> ntLayout , Character cr asString , ntShape , Character cr asString , ntEdges.

	ntEdges --> ntNode , '->' , ntNode | ntNode , '->' , ntNode , ' . ' , ntEdges.

	ntNode --> ntInt , ntInt , ntInt.

	ntShape --> 'RSEllipse' | 'RSCircle' | 'RSBox' | 'RSBitmap' | 'RSLabel' | 'RSPieSlice' | 'RSPolygon'.

	ntLayout --> 'RSClusteringLayout' | 'RSConditionalLayout' | 'RSNoLayout' | 'RSRectanglePackLayout' | 'RSSimpleForceBasedLayout'
	| 'RSCircleLayout' | 'RSCircularAroundAVertexLayout' | 'RSOvalLayout' | 'RSForceBasedLayout' | 'RSSunburstConstantWidthLayout'
	| 'RSSunburstExtentLayout' | 'RSFlowLayout' | 'RSHorizontalFlowLayout' | 'RSCellLayout' | 'RSGridLayout' | 'RSVerticalCellLayout'
	| 'RSAngleLineLayout' | 'RSHorizontalLineLayout' | 'RSVerticalLineLayout' | 'RSClusterTreeLayout' | 'RSSugiyamaLayout'
	| 'RSRectangleForceLayout' | 'RSEquidistantCircleLayout' | 'RSWeightedCircleLayout' | 'RSRadialTreeLayout'
	| 'RSClusterRadialTreeLayout' | 'RSHorizontalDominanceTreeLayout' | 'RSHorizontalTreeLayout' | 'RSDominanceTreeLayout'
	| 'RSTreeLayout' | 'RSHorizontalVanDerPloegTreeLayout' | 'RSVanDerPloegTreeLayout'.

	ntInt --> ($0 - $9).

	^ ntGraphConfig
]
