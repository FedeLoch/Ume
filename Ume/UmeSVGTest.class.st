Class {
	#name : 'UmeSVGTest',
	#superclass : 'TestCase',
	#instVars : [
		'argumentConstraints',
		'schema',
		'receiverConstraint'
	],
	#category : 'Ume-Framework Tests',
	#package : 'Ume',
	#tag : 'Framework Tests'
}

{ #category : 'running' }
UmeSVGTest >> setUp [

	super setUp.
	self timeLimit: 5 hours.
	
	receiverConstraint := UmeObjectConstraint new generator: (UmeConstantGenerator new value: SVGRunner).
	argumentConstraints := { UmeObjectConstraint new objectClass: String; generator: self svgGenerator }.
	
	schema := UmeSchema new
		          receiverConstraint: receiverConstraint;
		          argumentConstraints: argumentConstraints;
		          score: [ :re :inputs :res | 1 ];
		          property: [ :regex :input :result | true ];
					 method: SVGRunner class >> #run:.

]

{ #category : 'as yet unclassified' }
UmeSVGTest >> svgGenerator [

	^ self subclassResponsibility 
]
