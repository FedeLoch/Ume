Class {
	#name : 'UmeHDDShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'ddMin',
		'seen',
		'ddmin'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeHDDShrinker >> currentChildrenAssociations: tree atLevel: level [

	^ (tree allNodesAtLevel: level) inject: Dictionary new into: [ :dict :child |
			child parent ifNotNil: [ dict at: child parent ifAbsentPut: child parent children copy ].
			dict
		]
]

{ #category : 'shrinking' }
UmeHDDShrinker >> ddmin: candidates upperBound: bound [

	^ ddmin minimizeOne: candidates upperBound: bound
]

{ #category : 'testing' }
UmeHDDShrinker >> grammar: aGrammar [

	super grammar: aGrammar.
	ddmin grammar: aGrammar
]

{ #category : 'shrinking' }
UmeHDDShrinker >> hddmin: tree upperBound: bound level: level [
	
		| candidates minimized currentChildren |
		
		candidates := tree allNodesAtLevel: level.
		(candidates size <= 1) ifTrue: [ ^ nil ].
		
		currentChildren := self currentChildrenAssociations: tree atLevel: level.
	
		ddmin oracle: (UmeBooleanInputOracle from: [ :possibleNewChilds | | toDelete trigger |
			toDelete := candidates difference: possibleNewChilds.
			toDelete do: [ :childToDelete | | parent |
				parent := childToDelete parent.
				parent ifNotNil: [ parent removeChild: childToDelete ]
			].
			
			trigger := self triggerBug: tree upperBound: bound.
			trigger ifFalse: [
				currentChildren keysDo: [ :parent |
					parent children: (OrderedCollection withAll: (currentChildren at: parent))
				]
			] ifTrue: [
				currentChildren := self currentChildrenAssociations: tree atLevel: level.
			].
			trigger
		]).
		
		"DDMIN classic"
		minimized := self ddmin: candidates upperBound: bound.

		(candidates difference: minimized) do: [ :childToDelete | | parent |
			parent := childToDelete parent.
			parent ifNotNil: [ parent removeChild: childToDelete ]
		].
]

{ #category : 'shrinking' }
UmeHDDShrinker >> initialize [ 

	super initialize.
	seen := Set new.
	ddmin := UmeDDCustomShrinker new caller: self.
]

{ #category : 'shrinking' }
UmeHDDShrinker >> minimizeOne: originalTree upperBound: bound [

	| currentLevel tree |

	tree := self tree: originalTree asInput.
	
	currentLevel := 1.
   [ currentLevel <= tree treeHeight ] whileTrue: [ 
		self hddmin: tree upperBound: bound level: currentLevel.		
		currentLevel := currentLevel + 1.
	].

	^ tree
]

{ #category : 'shrinking' }
UmeHDDShrinker >> oracle: anOracle [

	super oracle: anOracle.
]

{ #category : 'shrinking' }
UmeHDDShrinker >> seen [

	^ seen
]

{ #category : 'shrinking' }
UmeHDDShrinker >> seen: aInput [

	seen := aInput 
]

{ #category : 'shrinking' }
UmeHDDShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]
