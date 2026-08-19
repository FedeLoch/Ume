Class {
	#name : 'UmeDDminFuzzingBookShrinker',
	#superclass : 'UmeShrinker',
	#instVars : [
		'splittingValue',
		'seen'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeDDminFuzzingBookShrinker >> asInput: aString [

	^ aString
]

{ #category : 'testing' }
UmeDDminFuzzingBookShrinker >> getComplement: array start: start length: length [
	
	^ (array copyFrom: 1 to: start), 
     (array copyFrom: (start + 1 + length min: array size + 1) to: array size)
]

{ #category : 'shrinking' }
UmeDDminFuzzingBookShrinker >> initialize [ 

	super initialize.
	seen := Set new
]

{ #category : 'shrinking' }
UmeDDminFuzzingBookShrinker >> minimizeOne: aInput upperBound: bound [

	^ self minimizeOneFuzzingBook: aInput upperBound: bound
]

{ #category : 'shrinking' }
UmeDDminFuzzingBookShrinker >> minimizeOneFuzzingBook: aInput upperBound: bound [

	"TODO: Fuzzing book implementation"
	
	| currentInput granularity start subsetLength someComplementFailing |

	currentInput := aInput .
	granularity := 2.
	
	[ currentInput isNotEmpty ] whileTrue: [
		start:= 0.
		subsetLength := currentInput size // granularity.
		someComplementFailing := false.
		
		[ (start < currentInput size) and: [ someComplementFailing not ] ] whileTrue: [ | complement |
			self minimizationDone.

			complement := self getComplement: currentInput start: start length: subsetLength.
			(complement = currentInput) ifTrue: [ ^ currentInput ].
			
			(self triggerBug: complement upperBound: bound) ifTrue: [
				currentInput := complement.
				granularity := (granularity - 1) max: 2.
				someComplementFailing := true
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
UmeDDminFuzzingBookShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
UmeDDminFuzzingBookShrinker >> sizeOf: string [

	^ string size

]

{ #category : 'shrinking' }
UmeDDminFuzzingBookShrinker >> tree: aString [

	^ aString. 
]

{ #category : 'shrinking' }
UmeDDminFuzzingBookShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]
