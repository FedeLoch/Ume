Class {
	#name : 'UmeDeltaDebugger',
	#superclass : 'UmeShrinker',
	#instVars : [
		'oracle',
		'splitingValue',
		'shrinker'
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

	^ ( oracle value: input )
]

{ #category : 'testing' }
UmeDeltaDebugger >> initialize [ 
	
	super initialize.
	splitingValue := 2.
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> minimizeOne: aInput upperBound: bound [
	| inputSlice|
	
	(0 < aInput size and: splitingValue <= aInput size) ifTrue: [ 
		inputSlice := self split: aInput into: splitingValue. 
		inputSlice do: [ :aSubInput |
			(self triggerBug: aSubInput upperBound:bound ) ifTrue: [ 
				^ aSubInput]].
	].
	^ aInput .

]

{ #category : 'shrinking' }
UmeDeltaDebugger >> oracle [ 
	
	^ oracle 
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> oracle: anOracle [

	oracle := anOracle
]

{ #category : 'private' }
UmeDeltaDebugger >> split: subInput into: aValue [

	| result sliceSize start end |
	
	result := OrderedCollection new. 
	"
	subInput size == splitingValue ifTrue: [ ^ subInput collect: #toString ]. ""?"""

	subInput size == splitingValue ifTrue: [ result add: (subInput copyFrom: 1 to: 1 ); add: (subInput copyFrom: 2 to: 2). ^result ].
	
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
UmeDeltaDebugger >> splitingValue [

	^splitingValue
]

{ #category : 'accessing' }
UmeDeltaDebugger >> splitingValue: aValue [

	splitingValue := aValue 
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> tree: aString [

	^ aString. 
]

{ #category : 'testing' }
UmeDeltaDebugger >> triggerBug: string upperBound: _ [
	
	^ (self evalInput: string) not
	

]
