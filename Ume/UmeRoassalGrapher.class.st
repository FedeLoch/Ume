Class {
	#name : 'UmeRoassalGrapher',
	#superclass : 'Object',
	#category : 'Ume-Paper Experimentation',
	#package : 'Ume',
	#tag : 'Paper Experimentation'
}

{ #category : 'running' }
UmeRoassalGrapher class >> run: graphDescrption [

	| line eb lines layoutClass shapeClass edges shapes c |
	lines := graphDescrption lines.
	layoutClass := self environment at: lines first.
	shapeClass := self environment at: lines second.
	edges := OpalCompiler new evaluate: '{', lines third, '}'.
	1 halt.

	line := RSLineBuilder arrowedDirectedBezier.

	shapes := ((edges collect: #key) , (edges collect: [ :e | e value ])) asSet asArray collect: [ :m |
			          shapeClass new
				          draggable;
				          model: m;
				          size: 5;
				          yourself ].

	c := RSCanvas new.
	c addAll: shapes.
	eb := line.
	eb canvas: c.
	eb useAssociations: edges.

	layoutClass on: shapes.
	shapes do: [ :e | e translateBy: 0 @ 0 ].
	c @ RSCanvasController.
	c asForm
]
