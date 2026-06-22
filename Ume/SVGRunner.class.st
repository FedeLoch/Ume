Class {
	#name : 'SVGRunner',
	#superclass : 'Object',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'running' }
SVGRunner class >> run: svgPath [

	| c svg |
	c := RSCanvas new.
	svg := RSSVGPath new
		       color: Color blue;
		       svgPath: svgPath.
	c add: svg.
	c @ RSCanvasController.
	c
]
