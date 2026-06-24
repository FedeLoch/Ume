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
		'ntStart',
		'ntTrace',
		'ntNbSep'
	],
	#category : 'Ume-Grammars',
	#package : 'Ume',
	#tag : 'Grammars'
}

{ #category : 'initialization' }
SvgPathGrammar >> defineGrammar [ 

	ntPath --> ntStart.
	
	ntStart --> ntMove, ntSep, ntTrace | ntMove.
	
	ntTrace --> ntCommand, ntSep, ntTrace | ntCommand | ntCommand, ntSep, ntStraight, ntSep, ntTrace | ntCommand, ntSep, ntStraight.
	
	ntCommand --> ntMove | ntLine | ntHorizontalLine | ntVerticalLine | ntCubicCurve | ntSmoothCubicCurve | ntQuadraticCurve | ntSmoothQuadraticCurve | ntArc. 
	
	ntMove --> 'M', ntPoint | 'm',ntPoint .
	
	ntLine --> 'L', ntPoint | 'l', ntPoint .
	
	ntHorizontalLine --> 'H', ntDecimal | 'h', ntDecimal.
	
	ntVerticalLine --> 'V', ntDecimal | 'v', ntDecimal. 
	
	ntStraight --> 'Z' | 'z'. 
	
	ntCubicCurve --> 'C', ntPoint , ntNbSep , ntPoint , ntNbSep , ntPoint | 'c', ntPoint , ntNbSep , ntPoint , ntNbSep , ntPoint . 
	
	ntSmoothCubicCurve --> 'S', ntPoint , ntNbSep, ntPoint | 's', ntPoint , ntNbSep, ntPoint .
		
	ntQuadraticCurve --> 'Q', ntPoint , ntNbSep , ntPoint | 'q', ntPoint , ntNbSep, ntPoint .
	
	ntSmoothQuadraticCurve --> 'T', ntPoint , ntNbSep, ntPoint | 't', ntPoint , ntNbSep, ntPoint .
	
	ntArc --> 'A', ntRadius, ntRadius , ntRotation , ntFlag , ntFlag , ntPoint | 'a', ntRadius, ntRadius , ntRotation , ntFlag , ntFlag , ntPoint.
	
	ntInt --> ($0 - $9).
	 
	ntPoint --> ntDecimal, ntNbSep , ntDecimal.
	
	ntDecimal --> '-', ntFloat | '-', ntDigit | ntFloat | ntDigit. 
	
	ntSep --> ' ' | ''.
	
	ntNbSep --> ' ' | ','.
	
	ntFloat --> ntDigit, '.', ntDigit. 
	
	ntRadius --> ntDecimal. 
	
	ntRotation --> ntDecimal. 
	
	ntFlag --> '0' | '1'.
	
	ntDigit --> ntInt | ntInt, ntDigit. 
	
	^ ntPath. 
]
