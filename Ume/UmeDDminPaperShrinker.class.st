Class {
	#name : 'UmeDDminPaperShrinker',
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
UmeDDminPaperShrinker >> asInput: aString [

	^ aString
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> candidates: cFail minus: cPass partition: n at: i [

	| delta elements from to |
	
	"used by general delta debugging"
	
	delta := cFail difference: cPass.
	elements := delta asArray.
	
	from := i - 1 * elements size // n + 1.
	to := i * elements size // n.

	^ elements copyFrom: from to: to
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> candidates: cFail partition: n at: i [

	| elements from to |
	
	"used by minimizing delta debugging"
	elements := cFail asArray.
	
	from := i - 1 * elements size // n + 1.
	to := i * elements size // n.

	^ elements copyFrom: from to: to
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> dd2: cFail safe: cPass upperBound: bound granularity: n [
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
UmeDDminPaperShrinker >> dd: cFail upperBound: bound [

	| resultPair |
	
	seen := Set new.
	
	"First is the safe array subset"
	"Second is the minimum array subset taht triggers the bug"
	
	"General delta debugging algorithm"
	resultPair := self dd2: cFail safe: {} upperBound: bound granularity: 2.
	
	^ cFail class withAll: resultPair second
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> ddmin2: cFail upperBound: bound granularity: n [
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
UmeDDminPaperShrinker >> ddmin: cFail upperBound: bound [

	| minimized |

	seen := Set new.
	
	minimized := self ddmin2: cFail upperBound: bound granularity: 2.
	
	^ cFail class withAll: minimized
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> initialize [ 

	super initialize.
	seen := Set new
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> minimizeOne: aInput upperBound: bound [

	^ self minimizeOnePaper: aInput upperBound: bound
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> minimizeOnePaper: cFail upperBound: bound [

	"General algorithm"
	"^ self dd: cFail upperBound: bound."
	
	"Ddmin classic"
	^ self ddmin: cFail upperBound: bound
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> sizeOf: string [

	^ string size

]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> tree: aString [

	^ aString. 
]

{ #category : 'shrinking' }
UmeDDminPaperShrinker >> triggerBug: tree upperBound: originalScore [

	|input|
	
	input := (self asInput: tree).

	^ oracle accepts: input from: originalScore
]
