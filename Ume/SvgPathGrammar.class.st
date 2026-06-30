Class {
	#name : 'SvgPathGrammar',
	#superclass : 'GncGrammar',
	#instVars : [
		'ntStart',
		'ntPath',
		'ntMove',
		'ntSep',
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
		'ntAParams',
		'ntCommands',
		'ntNegPointsPlus'
	],
	#category : 'Ume-Grammars',
	#package : 'Ume',
	#tag : 'Grammars'
}

{ #category : 'initialization' }
SvgPathGrammar >> defineGrammar [

	ntPath --> ntStart.
	
	ntStart --> ntMove | ntMove, ntSep, ntCommands. 
	
	ntCommands --> ntCommand | ntCommand, ntSep, ntCommands.
	
	ntCommand --> ntMove | ntLine | ntHorizontalLine | ntVerticalLine
				| ntCubicCurve | ntSmoothCubicCurve | ntQuadraticCurve
				| "ntSmoothQuadraticCurve |" ntArc | ntStraight.
					"T Not implemented yet"

	ntMove --> ntM, ntSep, ntPointsPlus.
	ntLine --> ntL, ntSep, ntPointsPlus.

	ntPointsPlus --> ntPoint | ntPoint, ntNbSep, ntPointsPlus | ntPoint, ntNegPointsPlus .

	ntNegPointsPlus --> ntNegPoint | ntNegPoint, ntNbSep, ntPointsPlus | ntNegPoint, ntNegPointsPlus. 

	ntHorizontalLine --> ntH, ntSep, ntDecimal.
	ntVerticalLine --> ntV, ntSep, ntDecimal. "s"

	ntStraight --> ntZ, ntSep.

	ntCubicCurve --> ntC, ntSep, ntThreePointsPlus.
	
	ntSmoothCubicCurve --> ntS, ntSep, ntTwoPointsPlus.
	ntQuadraticCurve --> ntQ, ntSep, ntTwoPointsPlus.

	ntSmoothQuadraticCurve --> ntT, ntSep, ntPointsPlus.

	ntArc --> ntA, ntSep | "This case is not supported by the vector definition, but it is accepted by the runner"
				 ntA, ntSep, ntAparamsPlus.
		
	ntAparamsPlus --> ntAParams, ntSep | ntAParams, ntNbSep, ntAparamsPlus, ntSep.
	ntAParams --> ntRadius , ntNbSep, ntRadius , ntNbSep, ntRotation , ntNbSep, ntFlag , ntNbSep, ntFlag, ntNbSep, ntPoint.
	
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
