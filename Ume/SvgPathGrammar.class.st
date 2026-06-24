Class {
	#name : 'SvgPathGrammar',
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
		'ntArc',
		'ntInt',
		'ntPoint',
		'ntRadius',
		'ntRotation',
		'ntFlag',
		'ntPath',
		'ntCommand',
		'ntDecimal',
		'ntSep',
		'ntFloat',
		'ntStart'
	],
	#category : 'Ume-Grammars',
	#package : 'Ume',
	#tag : 'Grammars'
}

{ #category : 'initialization' }
SvgPathGrammar >> defineGrammar [ 

	ntPath --> ntStart.
	
	ntStart --> ntCommand, ntSep , ntStart | ntCommand.
	
	ntCommand --> ntMove | ntLine | ntHorizontalLine | ntVerticalLine | ntStraight | ntCubicCurve | ntSmoothCubicCurve | ntQuadraticCurve | ntSmoothQuadraticCurve | ntArc. 
	
	ntMove --> 'M', ntPoint | 'm',ntPoint .
	
	ntLine --> 'L', ntPoint | 'l', ntPoint .
	
	ntHorizontalLine --> 'H', ntDecimal | 'h', ntDecimal.
	
	ntVerticalLine --> 'V', ntDecimal | 'v', ntDecimal. 
	
	ntStraight --> 'Z' | 'z'. 
	
	ntCubicCurve --> 'C', ntPoint , ntSep , ntPoint , ntSep , ntPoint | 'c', ntPoint , ntSep , ntPoint , ntSep , ntPoint . 
	
	ntSmoothCubicCurve --> 'S', ntPoint , ntSep, ntPoint | 's', ntPoint , ntSep, ntPoint .
		
	ntQuadraticCurve --> 'Q', ntPoint , ntSep , ntPoint | 'q', ntPoint , ntSep, ntPoint .
	
	ntSmoothQuadraticCurve --> 'T', ntPoint , ntSep, ntPoint | 't', ntPoint , ntSep, ntPoint .
	
	ntArc --> 'A', ntRadius, ntRadius , ntRotation , ntFlag , ntFlag , ntPoint | 'a', ntRadius, ntRadius , ntRotation , ntFlag , ntFlag , ntPoint.
	
	ntInt --> ($0 - $9).
	 
	ntPoint --> ntDecimal, ntSep, ntDecimal.
	
	ntDecimal --> '-', ntFloat | '-', ntDigit | ntFloat | ntDigit. 
	
	ntSep --> ' ' | ',' | ''.
	
	ntFloat --> ntDigit, '.', ntDigit. 
	
	ntRadius --> ntDecimal. 
	
	ntRotation --> ntDecimal. 
	
	ntFlag --> '0' | '1'.
	
	ntDigit --> ntInt | ntInt, ntDigit. 
	
	^ ntPath. 
]
