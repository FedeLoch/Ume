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
UmeSubTreeReducer >> initialize [ 

	super initialize. 
	subtreeShrinker := UmeGRABRShrinker new.
	subtreeShrinker reductionStrategy: UmeSimplifyGrammarSubtreeReducer.
]

{ #category : 'as yet unclassified' }
UmeSubTreeReducer >> reduce: aTree bound: bound [

	| minimizedTree |
	
	minimizedTree := subtreeShrinker minimizeOne: aTree upperBound: bound.
	self minimizationDone: (subtreeShrinker getMinimizationDone).
	self failedMinimization: (subtreeShrinker getFailedMinimization).
	
	^ minimizedTree
]
