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

{ #category : 'shrinking' }
UmeDDShrinker >> candidateOf: cFail minus: cPass partition: n at: i [

	| delta elements from to j |
	delta := cFail difference: cPass.
	
	elements := delta asArray.

	j := i - 1 max: 0.

	from := j * elements size // n + 1.
	to := i * elements size // n.

	^ (elements copyFrom: from to: to) asSet
]

{ #category : 'shrinking' }
UmeDDShrinker >> ddmin2: cFail safe: cPass upperBound: bound granularity: n [
	"Paper: https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf"

    | delta deltaSize partition range |

    delta := cFail difference: cPass.
    deltaSize := delta size.

    deltaSize <= 1 ifTrue: [ ^ { cPass . cFail } ].

    partition := (n max: 2) min: deltaSize.
    range := 1 to: partition.

    "Reduce to subset"
    range do: [ :i | | deltaI current |
        deltaI := self candidateOf: cFail minus: cPass partition: partition at: i.
        current := cPass union: deltaI.

        (self triggerBug: current upperBound: bound) ifTrue: [
            ^ self ddmin2: current safe: cPass upperBound: bound granularity: 2
        ]
    ].

    "Increase to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidateOf: cFail minus: cPass partition: partition at: i.
        current := cFail difference: deltaI.

        (self triggerBug: current upperBound: bound) ifFalse: [
            ^ self ddmin2: cFail safe: current upperBound: bound granularity: 2
        ]
    ].

    "Increase to subset"
    range do: [ :i | | deltaI current |
        deltaI := self candidateOf: cFail minus: cPass partition: partition at: i.
        current := cPass union: deltaI.

        (self triggerBug: current upperBound: bound) ifFalse: [
            ^ self ddmin2: cFail safe: current upperBound: bound granularity: ((partition - 1) max: 2)
        ]
    ].

    "Reduce to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidateOf: cFail minus: cPass partition: partition at: i.
        current := cFail difference: deltaI.

        (self triggerBug: current upperBound: bound) ifTrue: [
            ^ self ddmin2: current safe: cPass upperBound: bound granularity: ((partition - 1) max: 2)
        ]
    ].

    "Increase granularity"
    partition < deltaSize ifTrue: [
        ^ self ddmin2: cFail safe: cPass upperBound: bound granularity: ((2 * partition) min: deltaSize)
    ].

    ^ { cPass . cFail }
]

{ #category : 'testing' }
UmeDDShrinker >> getComplement: array start: start length: length [
	
	^ (array copyFrom: 1 to: start), 
     (array copyFrom: (start + 1 + length min: array size + 1) to: array size)
]

{ #category : 'shrinking' }
UmeDDShrinker >> minimizeOne: aInput upperBound: bound [

	^ self minimizeOnePaper: aInput upperBound: bound
]

{ #category : 'shrinking' }
UmeDDShrinker >> minimizeOneOld: aInput upperBound: bound [

	"TODO: Deprecated!!!!"
	
	| currentInput granularity start subsetLength someComplementFailing |
	1 halt.
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
UmeDDShrinker >> minimizeOnePaper: cFail upperBound: bound [
	
	| resultPair |
	
	"First is the safe array subset"
	"Second is the minimum array subset taht triggers the bug"
	resultPair := self ddmin2: cFail safe: {} upperBound: bound granularity: 2.
	
	^ cFail class withAll: resultPair second
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
