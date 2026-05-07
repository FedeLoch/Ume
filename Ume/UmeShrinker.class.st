Class {
	#name : 'UmeShrinker',
	#superclass : 'Object',
	#instVars : [
		'maxIterations'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeShrinker >> asInput: tree [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeShrinker >> evalInput: input [

	self subclassResponsibility 
]

{ #category : 'testing' }
UmeShrinker >> initialize [ 
	
	super initialize.
	maxIterations := 1000.
]

{ #category : 'shrinking' }
UmeShrinker >> minimize: tree upperBound: bound [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeShrinker >> shrink: input [
	
    | tree minimizedTree minimizedInput upperBound currentInput |
    
    currentInput := input copy.

    (self tree: input) ifNil: [ ^ input ].
    upperBound := self evalInput: input.
        
    maxIterations timesRepeat: [
		tree := self tree: currentInput.
		minimizedTree := self minimize: tree upperBound: upperBound.
		minimizedInput := self asInput: minimizedTree.
		
		(minimizedInput = currentInput) ifTrue: [ ^ currentInput ].
		
		currentInput := minimizedInput.
    ].
    
    ^ currentInput
]

{ #category : 'shrinking' }
UmeShrinker >> tree: input [

	self  subclassResponsibility 
]
