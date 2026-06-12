Class {
	#name : 'UmeDeltaDebugger',
	#superclass : 'UmeShrinker',
	#instVars : [
		'shrinker',
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

{ #category : 'shrinking' }
UmeDeltaDebugger >> evalInput: input [

	^ ( oracle isAccepted: input )
]

{ #category : 'testing' }
UmeDeltaDebugger >> initialize [ 
	
	super initialize.
	splittingValue := 2.
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> minimizeOne: stringInput upperBound: bound [
	
	| inputSlice|
	
	(0 < stringInput size and: splittingValue <= stringInput size) ifTrue: [ 
		inputSlice := self split: stringInput into: splittingValue. 
		inputSlice do: [ :aSubInput |
			self minimizationDone.
			(self triggerBug: aSubInput upperBound: bound)
				ifTrue: [ ^ aSubInput ]
				ifFalse: [ self failedMinimization ]
		].
	].

	^ stringInput

]

{ #category : 'shrinking' }
UmeDeltaDebugger >> sizeOf: string [

	^ string size

]

{ #category : 'private' }
UmeDeltaDebugger >> split: subInput into: aValue [

	| result sliceSize start end |
	
	result := OrderedCollection new. 
	"
	subInput size == splitingValue ifTrue: [ ^ subInput collect: #toString ]. ""?"""

	subInput size == splittingValue ifTrue: [ result add: (subInput copyFrom: 1 to: 1 ); add: (subInput copyFrom: 2 to: 2). ^result ].
	
	sliceSize := (subInput size / aValue ) ceiling.
	1 to: aValue do:[ :i |
		start := ((i -1) * sliceSize ) + 1.
		end := (start + sliceSize - 1) min: subInput size.
		start <= subInput size ifTrue:
			[ result add: (subInput copyFrom: start to: end )]
		].
	
	^ result 
]

{ #category : 'accessing' }
UmeDeltaDebugger >> splittingValue [

	^splittingValue
]

{ #category : 'accessing' }
UmeDeltaDebugger >> splittingValue: aValue [

	splittingValue := aValue 
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> tree: aString [

	^ aString. 
]

{ #category : 'testing' }
UmeDeltaDebugger >> triggerBug: string upperBound: _ [
	
	^ (self evalInput: string) not
	

]
