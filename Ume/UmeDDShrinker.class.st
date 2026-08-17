Class {
	#name : 'UmeDDShrinker',
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
UmeDDShrinker >> asInput: aString [

	^ aString
]

{ #category : 'shrinking' }
UmeDDShrinker >> candidates: cFail minus: cPass partition: n at: i [

	| delta elements from to |
	
	delta := cFail difference: cPass.
	elements := delta asArray.
	
	from := i - 1 * elements size // n + 1.
	to := i * elements size // n.

	^ elements copyFrom: from to: to
]

{ #category : 'shrinking' }
UmeDDShrinker >> ddmin2: cFail safe: cPass upperBound: bound granularity: n [
	"Paper: https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf"

    | delta deltaSize range key |

    delta := cFail difference: cPass.
    deltaSize := delta size.

	 key := { cFail }.
	
    (seen includes: key) ifTrue: [ ^ { cPass . cFail } ].	
    seen add: key.

    range := 1 to: n.

    "Reduce to subset"
    range do: [ :i | | deltaI current |
		  deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  	current := cPass union: deltaI.

        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self ddmin2: current safe: cPass upperBound: bound granularity: 2
        	]   
    ].

    "Increase to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  	current := cFail difference: deltaI.
        	(self triggerBug: current upperBound: bound) ifFalse: [
            	^ self ddmin2: cFail safe: current upperBound: bound granularity: 2
        	]
    ].

    "Increase to subset"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  	current := cPass union: deltaI.

        	(self triggerBug: current upperBound: bound) ifFalse: [
            	^ self ddmin2: cFail safe: current upperBound: bound granularity: ((n - 1) max: 2)
        	]
    ].

    "Reduce to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
			current := cFail difference: deltaI.

        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self ddmin2: current safe: cPass upperBound: bound granularity: ((n - 1) max: 2)
       	]
    ].

    "Increase granularity"
    n < deltaSize ifTrue: [
        ^ self ddmin2: cFail safe: cPass upperBound: bound granularity: ((2 * n) min: deltaSize)
    ].

    ^ { cPass . cFail }
]

{ #category : 'testing' }
UmeDDShrinker >> getComplement: array start: start length: length [
	
	^ (array copyFrom: 1 to: start), 
     (array copyFrom: (start + 1 + length min: array size + 1) to: array size)
]

{ #category : 'shrinking' }
UmeDDShrinker >> initialize [ 

	super initialize.
	seen := Set new
]

{ #category : 'shrinking' }
UmeDDShrinker >> minimizeOne: aInput upperBound: bound [

	^ self minimizeOnePaper: aInput upperBound: bound
]

{ #category : 'shrinking' }
UmeDDShrinker >> minimizeOneOld: aInput upperBound: bound [

	"TODO: Deprecated!!!!"
	
	| currentInput granularity start subsetLength someComplementFailing |

	currentInput := aInput .
	granularity := 2.
	1 halt.
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
	
	seen := Set new.
	
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
