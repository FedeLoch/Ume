Class {
	#name : 'UmeGRABRShrinker',
	#superclass : 'UmeShrinker',
	#instVars : [
		'grammar',
		'oracle',
		'reductionStrategy'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGRABRShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> checkGrammar: aInput [

	^ UmeGrammarParser accept: aInput from: grammar
]

{ #category : 'copying' }
UmeGRABRShrinker >> copyTree: tree [
 
	^ self tree: tree asInput
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> evalInput: input [

	^ ( oracle value: input )
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> grammar: aGrammar [

	grammar := aGrammar
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> minimizeOne: originalTree upperBound: bound [

	originalTree allNodes doWithIndex: [ :subTree :index | 
		( subTree isLeaf ) ifFalse: [ 
		| symbol |
		symbol := subTree tag. 
		( reductionStrategy reduce: subTree using: grammar matching: symbol ) do: [ :alternateSubtree |
			( alternateSubtree treeSize < originalTree treeSize) ifTrue: [ | newTree |
				newTree := self replaceSubtreeIn: originalTree by: alternateSubtree index: index.
				(self triggerBug: newTree upperBound: bound ) ifTrue: [ ^ newTree ] ]
				] 
			] 
		].
	
	^ originalTree
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> oracle [

	^ oracle
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> oracle: aOracle [

	oracle := aOracle
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> parse: input [

	^ UmeGrammarParser parse: input from: grammar
]

{ #category : 'accessing' }
UmeGRABRShrinker >> reductionStrategy [

	^ reductionStrategy
]

{ #category : 'accessing' }
UmeGRABRShrinker >> reductionStrategy: aStrategy [

	reductionStrategy := aStrategy
]

{ #category : 'copying' }
UmeGRABRShrinker >> replaceSubtreeIn: tree by: subtree index: index [

	| treeCopy |
	
	treeCopy := self copyTree: tree. 
	treeCopy replaceChildAt: index with: (subtree at: 2). 
	
	^ treeCopy. 
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> tree: input [

	^ self parse: input
]

{ #category : 'testing' }
UmeGRABRShrinker >> triggerBug: aTree upperBound: _ [

	|input|
	
	input := (self asInput: aTree).
	(self checkGrammar: input ) ifFalse: [ ^false ].

	^ (self evalInput: input ) not
]
