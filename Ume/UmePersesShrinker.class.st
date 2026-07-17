Class {
	#name : 'UmePersesShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'workList'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmePersesShrinker >> ddmin: tree node: node upperBound: bound [
]

{ #category : 'shrinking' }
UmePersesShrinker >> ddminPlus: tree node: node upperBound: bound [ 
]

{ #category : 'initialization' }
UmePersesShrinker >> initialize [ 

	super initialize.
	workList := Heap sortBlock: [ :node1 :node2 | node1 treeHeight < node2 treeHeight ] 
]

{ #category : 'shrinking' }
UmePersesShrinker >> minimizeOne: tree upperBound: bound [

	| best |
	
	best := tree.
	workList add: tree parent. 
	workList isEmpty whileFalse: [ 
		| largest pending |
		largest := workList removeFirst.
		" case by case reduction here 
		if Kleene:
		pending := self reduceKleene
		else: 
		pending := self reduceRegular"
		workList add pending
	].
	
	^ best
]

{ #category : 'shrinking' }
UmePersesShrinker >> reduceKleene: tree node: node upperBound: bound [ 

		
	
]

{ #category : 'shrinking' }
UmePersesShrinker >> reduceRegular: tree node: node upperBound: bound [ 

	| candidates |
	candidates := OrderedCollection new.
	
	
]

{ #category : 'shrinking' }
UmePersesShrinker >> shouldStop: minimized size: size from: currentTree size: currentSize [

]
