Class {
	#name : 'UmeReductionShrinker',
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
UmeReductionShrinker >> asInput: tree [

	^ tree "a changer"
]

{ #category : 'shrinking' }
UmeReductionShrinker >> evalInput: input [

	^ [ self method input ] on: Error do: [ ^ nil ]. "todo"
]

{ #category : 'testing' }
UmeReductionShrinker >> initialize [ 
	
	super initialize.
	splitingValue := 2.
]

{ #category : 'shrinking' }
UmeReductionShrinker >> minimizeOne: string upperBound: bound [
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
UmeReductionShrinker >> oracle [ 
	
	^ oracle 
]

{ #category : 'shrinking' }
UmeReductionShrinker >> oracle: anOracle [

	oracle := anOracle
]

{ #category : 'private' }
UmeReductionShrinker >> split: aString into: aValue [
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
UmeReductionShrinker >> splitingValue [

	^splitingValue
]

{ #category : 'accessing' }
UmeReductionShrinker >> splitingValue: aValue [

	splitingValue := aValue 
]

{ #category : 'shrinking' }
UmeReductionShrinker >> tree: input [

	^ input. 
]

{ #category : 'testing' }
UmeReductionShrinker >> triggerBug: string upperBound: _ [
	
	"[ method value: string  ] on: Error do: [^true.].
	"
	^ (oracle value: string) not "à modif"
	

]
