Class {
	#name : 'SvgPathGrammar',
	#superclass : 'GncGrammar',
	#instVars : [
		'ntStart',
		'ntPath',
		'ntMove',
		'ntSep',
		'ntTrace',
		'ntCommand',
		'ntStraight',
		'ntLine',
		'ntHorizontalLine',
		'ntVerticalLine',
		'ntCubicCurve',
		'ntSmoothCubicCurve',
		'ntQuadraticCurve',
		'ntSmoothQuadraticCurve',
		'ntArc',
		'ntM',
		'ntPoint',
		'ntL',
		'ntH',
		'ntDecimal',
		'ntV',
		'ntZ',
		'ntC',
		'ntThreePoints',
		'ntS',
		'ntTwoPoints',
		'ntQ',
		'ntT',
		'ntA',
		'ntRadius',
		'ntRotation',
		'ntFlag',
		'ntNbSep',
		'ntNegPoint',
		'ntInt',
		'ntNegDecimal',
		'ntNumDecimal',
		'ntFloat',
		'ntDigit',
		'ntPointsPlus',
		'ntThreePointsPlus',
		'ntTwoPointsPlus',
		'ntAparamsPlus',
		'ntAParams'
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
				| "ntSmoothQuadraticCurve |" ntArc.
					"T Not implemented yet"

	ntMove --> ntM, ntPointsPlus.
	ntLine --> ntL, ntPointsPlus.
	
	ntPointsPlus --> ntPoint | ntPoint, ntNbSep, ntPointsPlus.

	ntHorizontalLine --> ntH, ntDecimal.
	ntVerticalLine --> ntV, ntDecimal.

	ntStraight --> ntZ.

	ntCubicCurve --> ntC, ntThreePointsPlus.
	
	ntSmoothCubicCurve --> ntS, ntTwoPointsPlus.
	ntQuadraticCurve --> ntQ, ntTwoPointsPlus.

	ntSmoothQuadraticCurve --> ntT, ntPointsPlus.

	ntArc --> ntA | "This case is not supported by the vector definition, but it is accepted by the runner"
				 ntA, ntAparamsPlus.
		
	ntAparamsPlus --> ntAParams | ntAParams, ntNbSep, ntAparamsPlus.
	ntAParams --> ntRadius , ntRadius , ntRotation , ntFlag , ntFlag, ntPoint.
	
	ntThreePointsPlus --> ntThreePoints | ntThreePoints, ntNbSep, ntThreePointsPlus.
	ntThreePoints --> ntTwoPoints, ntNbSep, ntPoint | ntTwoPoints, ntNegPoint.
	
	ntTwoPointsPlus --> ntTwoPoints | ntTwoPoints, ntNbSep, ntTwoPointsPlus.
	ntTwoPoints --> ntPoint , ntNbSep , ntPoint | ntPoint , ntNegPoint.

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

	ntPoint --> ntDecimal , ntNbSep , ntDecimal | ntDecimal , ntNegDecimal.

	ntNegDecimal --> '-' , ntNumDecimal.

	ntNegPoint --> ntNegDecimal , ntNbSep , ntDecimal | ntNegDecimal , ntNegDecimal.

	ntDecimal --> '-' , ntNumDecimal | ntNumDecimal.
	
	ntNumDecimal -->  ntFloat | ntDigit.

	ntSep --> ' ' | ''.

	ntNbSep --> ' ' | ','.

	ntFloat --> ntDigit , '.' , ntDigit | ntDigit , '.' | '.', ntDigit.

	ntRadius --> ntDecimal.

	ntRotation --> ntDecimal.

	ntFlag --> '0' | '1'.

	ntDigit --> ntInt | ntInt , ntDigit.

	^ ntPath
]
