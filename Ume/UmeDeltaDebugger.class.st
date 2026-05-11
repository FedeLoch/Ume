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
UmeDeltaDebugger >> asInput: tree [

	^ tree "a changer"
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> evalInput: input [

	^ [ self method input ] on: Error do: [ ^ nil ]. "todo"
]

{ #category : 'testing' }
UmeDeltaDebugger >> initialize [ 
	
	super initialize.
	splitingValue := 2.
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> minimizeOne: string upperBound: bound [
	| currentInput parts|
	
	currentInput := string.
	(0 < string size) ifTrue: [ 
		| foundbetterInput |
		foundbetterInput := false.
		parts := self split: string into: splitingValue.
		parts do: [ :each |
			(self triggerBug: each upperBound:bound ) ifTrue: [ 
				currentInput := each.
				foundbetterInput := true.
				^ currentInput .]].
				"^ self minimizeOne: currentInput upperBound: bound. ]]."
	].
	^ currentInput .

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
UmeDeltaDebugger >> split: aString into: aValue [
"maybe add that as an extension"

	| result size start limit|
	
	result := OrderedCollection new. 
	( aString size == 2) ifTrue: [ result add: (aString copyFrom: 1 to: 1 ); add: (aString copyFrom: 2 to: 2). ^result].
	size := (aString size / aValue ) ceiling .
	1 to: aValue do:[ :i |
		start := ((i -1) * size ) + 1.
		limit := (start + size - 1) min: aString size.
		start <= aString size ifTrue: [ result add: (aString copyFrom: start to: limit )  ].
		].
	^result. 
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
UmeDeltaDebugger >> tree: input [

	^ input. 
]

{ #category : 'testing' }
UmeDeltaDebugger >> triggerBug: string upperBound: _ [
	
	"[ method value: string  ] on: Error do: [^true.].
	"
	^ (oracle value: string) not "à modif"
	

]
