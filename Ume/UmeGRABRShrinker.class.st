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

	| reducedTree |
	
	reducedTree:= self reductionOn: originalTree with: bound.

	"originalTree children do: [ :child | reducedTrees := reductionStrategy findCandidates: child using: grammar. ].
	reducedTrees do: [ :subtree |
		| treeCopy |
		1 halt.
		treeCopy:= self copyTree: originalTree.
		treeCopy replaceChild: subtree parent with: subtree.
		1 halt.]."
	
	^ reducedTree 
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

{ #category : 'as yet unclassified' }
UmeGRABRShrinker >> reductionOn: originalTree with: bound [
	
	| reducedTrees |

	reducedTrees := reductionStrategy reduce: originalTree using: grammar.
	reducedTrees do: [ :candidate |
		(self triggerBug: candidate upperBound: bound) ifTrue: [ ^ candidate ] 
	].

	^ nil
]

{ #category : 'accessing' }
UmeGRABRShrinker >> reductionStrategy [

	^ reductionStrategy
]

{ #category : 'accessing' }
UmeGRABRShrinker >> reductionStrategy: aStrategy [

	reductionStrategy := aStrategy
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> test: aTree with: bound [

	| allChildrens allSubTree|
	
	allSubTree := OrderedCollection new. 
	
	allChildrens := aTree allNodes.
	allChildrens do: [ :aSubTree |
		| candidate |
		(aSubTree isLeaf not) ifTrue: (candidate := reductionStrategy reduce: aSubTree).
		1 halt. 
		(self triggerBug: candidate upperBound: bound) ifTrue: [ allSubTree add: candidate ] ].

	^ allSubTree 
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
