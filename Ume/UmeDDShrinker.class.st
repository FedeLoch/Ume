Class {
	#name : 'UmeDDShrinker',
	#superclass : 'UmeShrinker',
	#instVars : [
		'splittingValue'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeDDShrinker >> asInput: aString [

	^ aString
]

{ #category : 'testing' }
UmeDDShrinker >> getComplement: array start: start length: length [

	| firstSlice secondSlice |

	firstSlice := 1 to: start.
	secondSlice := (start + length) to: array size.

	^ (firstSlice collect: [ :i | array at: i ]), (secondSlice collect: [ :i | array at: i ]) 
]

{ #category : 'testing' }
UmeDDShrinker >> initialize [ 
	
	super initialize.
]

{ #category : 'shrinking' }
UmeDDShrinker >> minimizeOne: aInput upperBound: bound [

	| currentInput granularity start subsetLength someComplementFailing |

	currentInput := aInput .
	granularity := 2.

	[currentInput size >= 2 ] whileTrue: [
		start:= 0.
		subsetLength := currentInput size // granularity.
		someComplementFailing := false.
		
		[ start < currentInput size ] whileTrue: [ | complement |
			self minimizationDone.

			complement := self getComplement: currentInput start: start length: subsetLength .
			(self triggerBug: complement upperBound: bound ) ifTrue: [
				currentInput := complement.
				granularity := (granularity - 1) max: 2.
				someComplementFailing := true.
			] ifFalse: [
				self failedMinimization.
				start := start + subsetLength
			]
		].
		
		someComplementFailing ifFalse: [ 
			(granularity = currentInput size) ifTrue:[ ^ currentInput ].
			granularity := (granularity * 2) min: currentInput size.
		 ]
	].

	^ currentInput

]

{ #category : 'shrinking' }
UmeDDShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
UmeDDShrinker >> sizeOf: string [

	^ string size

]

{ #category : 'shrinking' }
UmeDDShrinker >> tree: aString [

	^ aString. 
]

{ #category : 'shrinking' }
UmeDDShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]
