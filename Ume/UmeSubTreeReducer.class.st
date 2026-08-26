Class {
	#name : 'UmeSubTreeReducer',
	#superclass : 'UmeVulcanAuxiliaryReducer',
	#instVars : [
		'subtreeShrinker'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeSubTreeReducer >> grammar: aGrammar [

	super grammar: aGrammar.
	subtreeShrinker grammar: aGrammar 
]

{ #category : 'as yet unclassified' }
UmeSubTreeReducer >> initialize [ 

	super initialize. 
	subtreeShrinker := UmeGRABRShrinker new.
	subtreeShrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer. "only try to reduce by replacing subtrees with the same symbol"
]

{ #category : 'as yet unclassified' }
UmeSubTreeReducer >> reduce: aTree bound: bound [

	| minimizedTree |
	
	minimizedTree := subtreeShrinker minimizeOne: aTree upperBound: bound.
	self minimizationDone: (subtreeShrinker getMinimizationDone).
	self failedMinimization: (subtreeShrinker getFailedMinimization).
	
	^ minimizedTree
]
