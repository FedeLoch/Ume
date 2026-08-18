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
	
	"used by general delta debugging"
	
	delta := cFail difference: cPass.
	elements := delta asArray.
	
	from := i - 1 * elements size // n + 1.
	to := i * elements size // n.

	^ elements copyFrom: from to: to
]

{ #category : 'shrinking' }
UmeDDShrinker >> candidates: cFail partition: n at: i [

	| elements from to |
	
	"used by minimizing delta debugging"
	elements := cFail asArray.
	
	from := i - 1 * elements size // n + 1.
	to := i * elements size // n.

	^ elements copyFrom: from to: to
]

{ #category : 'shrinking' }
UmeDDShrinker >> dd2: cFail safe: cPass upperBound: bound granularity: n [
	"Paper: https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf"

    | delta deltaSize range key |

    delta := cFail difference: cPass.
    deltaSize := delta size.

	 key := { cFail . cPass . n }.
	
    (seen includes: key) ifTrue: [ ^ { cPass . cFail } ].	
    seen add: key.

    range := 1 to: n.

    "Reduce to subset"
    range do: [ :i | | deltaI current |
		  deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  current := cPass union: deltaI.

        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self dd2: current safe: cPass upperBound: bound granularity: 2
        	]   
    ].

    "Increase to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  	current := cFail difference: deltaI.
        	(self triggerBug: current upperBound: bound) ifFalse: [
            	^ self dd2: cFail safe: current upperBound: bound granularity: 2
        	]
    ].

    "Increase to subset"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
		  	current := cPass union: deltaI.

        	(self triggerBug: current upperBound: bound) ifFalse: [
            	^ self dd2: cFail safe: current upperBound: bound granularity: ((n - 1) max: 2)
        	]
    ].

    "Reduce to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail minus: cPass partition: n at: i.
			current := cFail difference: deltaI.

        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self dd2: current safe: cPass upperBound: bound granularity: ((n - 1) max: 2)
       	]
    ].

    "Increase granularity"
    n < deltaSize ifTrue: [
        ^ self dd2: cFail safe: cPass upperBound: bound granularity: ((2 * n) min: deltaSize)
    ].

    ^ { cPass . cFail }
]

{ #category : 'shrinking' }
UmeDDShrinker >> dd: cFail upperBound: bound [

	| resultPair |
	
	seen := Set new.
	
	"First is the safe array subset"
	"Second is the minimum array subset taht triggers the bug"
	
	"General delta debugging algorithm"
	resultPair := self dd2: cFail safe: {} upperBound: bound granularity: 2.
	
	^ cFail class withAll: resultPair second
]

{ #category : 'shrinking' }
UmeDDShrinker >> ddmin2: cFail upperBound: bound granularity: n [
	"Paper: https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf"

    | range key |

	 key := { cFail . n }.
	
    (seen includes: key) ifTrue: [ ^ cFail ].	
    seen add: key.

    range := 1 to: n.

    "Reduce to subset"
    range do: [ :i | | deltaI |
		  deltaI := self candidates: cFail partition: n at: i.

        	(self triggerBug: deltaI upperBound: bound) ifTrue: [
            	^ self ddmin2: deltaI upperBound: bound granularity: 2
        	]   
    ].

    "Reduce to complement"
    range do: [ :i | | deltaI current |
        deltaI := self candidates: cFail partition: n at: i.
			current := cFail difference: deltaI.

        	(self triggerBug: current upperBound: bound) ifTrue: [
            	^ self ddmin2: current upperBound: bound granularity: ((n - 1) max: 2)
       	]
    ].

    "Increase granularity"
    n < (cFail size) ifTrue: [
        ^ self ddmin2: cFail upperBound: bound granularity: ((2 * n) min: (cFail size))
    ].

    ^ cFail
]

{ #category : 'shrinking' }
UmeDDShrinker >> ddmin: cFail upperBound: bound [

	| minimized |

	seen := Set new.
	
	minimized := self ddmin2: cFail upperBound: bound granularity: 2.
	
	^ cFail class withAll: minimized
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

	"^ self minimizeOneFuzzingBook: aInput upperBound: bound"
	^ self minimizeOnePaper: aInput upperBound: bound
]

{ #category : 'shrinking' }
UmeDDShrinker >> minimizeOneFuzzingBook: aInput upperBound: bound [

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
UmeDDShrinker >> minimizeOnePaper: cFail upperBound: bound [

	"General algorithm"
	"^ self dd: cFail upperBound: bound."
	
	"Ddmin classic"
	^ self ddmin: cFail upperBound: bound
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
