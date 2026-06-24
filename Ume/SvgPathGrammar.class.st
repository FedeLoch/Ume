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
		'ntNbSep',
		'ntTwoPoints',
		'ntThreePoints',
		'ntM',
		'ntL',
		'ntH',
		'ntV',
		'ntZ',
		'ntC',
		'ntS',
		'ntQ',
		'ntT',
		'ntA',
		'ntNumDecimal'
	],
	#category : 'Ume-Grammars',
	#package : 'Ume',
	#tag : 'Grammars'
}

{ #category : 'initialization' }
SvgPathGrammar >> defineGrammar [

	ntPath --> ntStart.

	ntStart --> ntMove , ntSep , ntTrace | ntMove.

	ntTrace --> ntCommand , ntSep , ntTrace | ntCommand |
		ntCommand, ntSep , ntStraight , ntSep , ntTrace | ntCommand , ntSep , ntStraight.

	ntCommand --> ntMove | ntLine | ntHorizontalLine | ntVerticalLine
				| ntCubicCurve | ntSmoothCubicCurve | ntQuadraticCurve
				| ntSmoothQuadraticCurve | ntArc.

	ntMove --> ntM, ntPoint.

	ntLine --> ntL, ntPoint.

	ntHorizontalLine --> ntH, ntDecimal.

	ntVerticalLine --> ntV, ntDecimal.

	ntStraight --> ntZ.

	ntCubicCurve --> ntC, ntThreePoints.
	
	ntSmoothCubicCurve --> ntS, ntTwoPoints.

	ntQuadraticCurve --> ntQ, ntTwoPoints.

	ntSmoothQuadraticCurve --> ntT, ntTwoPoints.

	ntArc --> ntA, ntRadius , ntRadius , ntRotation , ntFlag , ntFlag, ntPoint.
	
	ntThreePoints --> ntTwoPoints, ntNbSep, ntPoint.
	
	ntTwoPoints --> ntPoint , ntNbSep , ntPoint.

	ntInt --> ($0 - $9).
	
	ntA --> 'A' | 'a'.
	ntM --> 'M' | 'm'.
	ntL --> 'L' | 'l'.
	ntH --> 'H' | 'h'.
	ntV --> 'V' | 'v'.
	ntZ --> 'Z' | 'z'.
	ntC --> 'C' | 'c'.
	ntS --> 'S' | 's'.
	ntT --> 'T' | 't'.
	ntQ --> 'Q' | 'q'.

	ntPoint --> ntDecimal , ntNbSep , ntDecimal.

	ntDecimal --> '-' , ntNumDecimal | ntNumDecimal.
	
	ntNumDecimal -->  ntFloat | ntDigit.

	ntSep --> ' ' | ''.

	ntNbSep --> ' ' | ','.

	ntFloat --> ntDigit , '.' , ntDigit.

	ntRadius --> ntDecimal.

	ntRotation --> ntDecimal.

	ntFlag --> '0' | '1'.

	ntDigit --> ntInt | ntInt , ntDigit.

	^ ntPath
]
