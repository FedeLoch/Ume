Class {
	#name : 'UmeGraphCodeParserGenerator',
	#superclass : 'UmeParserGenerator',
	#category : 'Ume-Generators',
	#package : 'Ume',
	#tag : 'Generators'
}

{ #category : 'as yet unclassified' }
UmeGraphCodeParserGenerator >> parse: grammarBasedInput [

	| lines layout shape edges |
	lines := grammarBasedInput lines.
	layout := lines first.
	shape := lines second.
	edges := lines third.
	1 halt.
"| c shapes eb |
edges := (1 to: 100) collect: [ :e |
    e -> (e + 1)
].
shape := RSEllipse.

line := RSLineBuilder arrowedDirectedBezier.
layout := RSSugiyamaLayout .

shapes := ((edges collect: #key), (edges collect: [:e | e value])) asSet asArray
    collect: [ :m | shape new draggable; model: m; size: 5; yourself ].

[
    c := RSCanvas new.
c addAll: shapes.
eb := line.
eb canvas: c.
eb useAssociations: edges.

layout on: shapes.
shapes do: [ :e | e translateBy: 0 @ 0 ].
c @ RSCanvasController.
c asForm] timeToRun"
	1 halt.
	
]
