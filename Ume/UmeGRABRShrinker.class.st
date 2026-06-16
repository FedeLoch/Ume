Class {
	#name : 'UmeGRABRShrinker',
	#superclass : 'UmeShrinker',
	#instVars : [
		'reductionStrategy',
		'seen'
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
UmeGRABRShrinker >> candidates: subTree matching: symbol [

	| allCandidates |
	
	allCandidates := (reductionStrategy reduce: subTree using: grammar matching: symbol) asSet.

	^ allCandidates difference: seen
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
UmeGRABRShrinker >> initialize [ 

	super initialize.
	seen := Set new.
	reductionStrategy := UmeSimplifyGrammarBoth.
	
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> minimizeOne: originalTree upperBound: bound [

	originalTree allNodes doWithIndex: [ :subTree :index | 
		( subTree isLeaf ) ifFalse: [ | symbol |
			symbol := subTree tag. 
			( self candidates: subTree matching: symbol ) do: [ :candidate |
				seen add: candidate. 
				( candidate treeSize < originalTree treeSize) ifTrue: [ | newTree |
					newTree := self replaceSubtreeIn: originalTree by: candidate index: index.
					self minimizationDone.
					(self triggerBug: newTree upperBound: bound ) ifTrue: [
						^ newTree
					] ifFalse: [ self failedMinimization. ]
				]
			] 
		] 
	].
	
	^ originalTree
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

	| treeCopy replacementTree test|
	
	treeCopy := self copyTree: tree.  
	replacementTree := treeCopy at: index.
	test := OrderedCollection new. 
	test add: (subtree at: 2).
	replacementTree children: test.
	
	^ treeCopy 
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> tree: input [

	^ self parse: input
]

{ #category : 'testing' }
UmeGRABRShrinker >> triggerBug: aTree upperBound: _ [

	|input|
	
	input := (self asInput: aTree).
	(self checkGrammar: input ) ifFalse: [ ^ false ].

	^ oracle accepts: input from: _ 
]
