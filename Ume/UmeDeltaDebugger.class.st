Class {
	#name : 'UmeDeltaDebugger',
	#superclass : 'UmeShrinker',
	#instVars : [
		'splittingValue'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeDeltaDebugger >> asInput: aString [

	^ aString
]

{ #category : 'testing' }
UmeDeltaDebugger >> getComplement: input start: start length: subsetLength [

	| complement |
	complement := (input copyFrom: 1 to: start) , 
                 (input copyFrom: (start + subsetLength + 1 min: input size + 1) to: input size).

	^ complement 
]

{ #category : 'testing' }
UmeDeltaDebugger >> initialize [ 
	
	super initialize.
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> minimizeOne: aInput upperBound: bound [

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
				granularity := (granularity -1) max: 2.
				someComplementFailing := true.
				start := currentInput size.
			] ifFalse: [
				self failedMinimization.
				start := start + subsetLength
			]
		].
		
		someComplementFailing ifFalse: [ 
			(granularity = currentInput size) ifTrue:[
				^ currentInput ].
			granularity := (granularity*2) min: currentInput size.
		 ]
	].

	^ currentInput

]

{ #category : 'shrinking' }
UmeDeltaDebugger >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> sizeOf: string [

	^ string size

]

{ #category : 'shrinking' }
UmeDeltaDebugger >> tree: aString [

	^ aString
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]
