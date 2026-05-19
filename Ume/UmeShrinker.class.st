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
UmeShrinker >> minimizeOne: tree upperBound: bound [

	self subclassResponsibility 
]

{ #category : 'shrinking' }
UmeShrinker >> minimizeTree: tree upperBound: bound [

	| currentTree |
	
	"This minimize as much as possible the input".
	currentTree := tree copy.
	maxIterations timesRepeat: [ | minimized |
		minimized := self minimizeOne: currentTree upperBound: bound.
		(minimized = currentTree) ifTrue: [ ^ currentTree ].
		
		currentTree := minimized.
	].

	^ currentTree
]

{ #category : 'shrinking' }
UmeShrinker >> shrink: input [

	| tree minimizedTree upperBound |

	(self tree: input) ifNil: [ ^ input ].
	upperBound := self evalInput: input.

	tree := self tree: input.
	minimizedTree := self minimizeTree: tree upperBound: upperBound.

	^ self asInput: minimizedTree
]

{ #category : 'shrinking' }
UmeShrinker >> tree: input [

	self  subclassResponsibility 
]

{ #category : 'testing' }
UmeShrinker >> triggerBug: score upperBound: originalScore [

	self subclassResponsibility 
]
