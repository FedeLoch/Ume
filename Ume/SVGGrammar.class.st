Class {
	#name : 'SVGGrammar',
	#superclass : 'GncGrammar',
	#instVars : [
		'ntMove',
		'ntDigit',
		'ntLine',
		'ntHorizontalLine',
		'ntVerticalLine',
		'ntStraight',
		'ntCubicCurve',
		'ntSmoothCubicCurve',
		'ntQuadraticCurve',
		'ntSmoothQuadraticCurve',
		'ntArc'
	],
	#category : 'Ume-Grammars',
	#package : 'Ume',
	#tag : 'Grammars'
}

{ #category : 'initialization' }
SVGGrammar >> defineGrammar [ 

	ntMove --> 'M', ntDigit, ntDigit | 'm', ntDigit, ntDigit.
	
	ntLine --> 'L', ntDigit, ntDigit | 'l', ntDigit, ntDigit.
	
	ntHorizontalLine --> 'H', ntDigit | 'h', ntDigit.
	
	ntVerticalLine --> 'V', ntDigit | 'v', ntDigit. 
	
	ntStraight --> 'Z' | 'z'. 
	
	ntCubicCurve --> 'C', ntDigit, ntDigit, ',', ntDigit, ntDigit, ',', ntDigit, ntDigit | 'c', ntDigit, ntDigit, ',', ntDigit, ntDigit, ',', ntDigit, ntDigit. 
	
	ntSmoothCubicCurve --> 'S', ntDigit, ntDigit, ',', ntDigit, ntDigit | 's', ntDigit, ntDigit, ',', ntDigit, ntDigit.
		
	ntQuadraticCurve --> 'Q', ntDigit, ntDigit, ',', ntDigit, ntDigit | 'q', ntDigit, ntDigit, ',', ntDigit, ntDigit.
	
	ntSmoothQuadraticCurve --> 'T', ntDigit, ntDigit, ',', ntDigit, ntDigit | 't', ntDigit, ntDigit, ',', ntDigit, ntDigit.
	
	ntArc --> 'A', ntDigit, ntDigit, ntDigit, ntDigit, ntDigit, ntDigit, ntDigit | 'a', ntDigit, ntDigit, ntDigit, ntDigit, ntDigit, ntDigit, ntDigit.
	 
	ntDigit --> ($0 - $9) | '-', ($0 - $9).
	

]
