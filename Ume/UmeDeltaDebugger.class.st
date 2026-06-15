Class {
	#name : 'UmeDeltaDebugger',
	#superclass : 'UmeShrinker',
	#instVars : [
		'oracle',
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
UmeDeltaDebugger >> getComplement: input start: start length: subsetLength [

	| complement |
	complement := (input copyFrom: 1 to: start) , 
                 (input copyFrom: (start + subsetLength + 1 min: input size + 1) to: input size).

	^ complement. 
]

{ #category : 'testing' }
UmeDeltaDebugger >> initialize [ 
	
	super initialize.
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> minimizeOne: aInput upperBound: bound [

	| currentInput n start subsetLength someComplementFailing |

	currentInput := aInput .
	n := 2.
	[currentInput size >= 2 ] whileTrue: [
		start:= 0.
		subsetLength := currentInput size // n.
		someComplementFailing := false.
		[ start < currentInput size ] whileTrue: [ 
			| complement |
			complement := self getComplement: currentInput start: start length: subsetLength .
			(self triggerBug: complement upperBound: bound ) ifTrue: [ 
				currentInput := complement.
				n := (n -1) max: 2.
				someComplementFailing := true.
				start := currentInput size.
			] ifFalse: [ 
			start := start+ subsetLength. ]].
		
		someComplementFailing ifFalse: [ 
			(n = currentInput size) ifTrue:[
				^ currentInput ].
			n := (n*2) min: currentInput size.
		 ]
	].

	^ currentInput 
	
	
	

]

{ #category : 'shrinking' }
UmeDeltaDebugger >> oracle [ 
	
	^ oracle 
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> oracle: anOracle [

	oracle := anOracle
]

{ #category : 'shrinking' }
UmeDeltaDebugger >> tree: aString [

	^ aString. 
]

{ #category : 'testing' }
UmeDeltaDebugger >> triggerBug: string upperBound: _ [
	
	^ (self evalInput: string) not
	

]
