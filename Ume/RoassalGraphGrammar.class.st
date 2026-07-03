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

	ntGraphConfig --> ntLayout, Character cr asString , ntShape , Character cr asString , ntEdges.

	ntEdges --> ntNode , '->' , ntNode | ntNode , '->' , ntNode , ',' , ntEdges.

	ntNode --> ntInt , ntInt , ntInt.

	ntShape --> 'RSEllipse' | 'RSCircle' | 'RSBox' | 'RSBitmap'.

	ntLayout --> 'RSSugiyamaLayout'
	| 'RSRadialTreeLayout'
	| 'RSHorizontalDominanceTreeLayout'
	| 'RSHorizontalVanDerPloegTreeLayout'
	| 'RSClusterRadialTreeLayout'.

	ntInt --> ($0 - $9).

	^ ntGraphConfig
]
