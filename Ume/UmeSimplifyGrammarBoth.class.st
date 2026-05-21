Class {
	#name : 'UmeSimplifyGrammarBoth',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> findCandidates: aTree using: aGrammar [

	| candidatesSubtree candidatesAlternate candidates|
	
	candidates := OrderedCollection new.
	 
	candidatesSubtree := (UmeSimplifyGrammarAlternateReduction findCandidates: aTree using: aGrammar).
	candidatesAlternate := (UmeSimplifyGrammarSubtreeReducer findCandidates: aTree using: aGrammar).
	candidates := candidatesSubtree, candidatesAlternate.  
	
	^ candidates 
]

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> reduce: aTree [

	1 halt. 
	
	aTree allNodes do: [ :subtree | 
		| reducedSubTree |
		reducedSubTree:= UmeSimplifyGrammarSubtreeReducer findCandidates: aTree by: subtree.
		reducedSubTree ifNotNil: [ ^ reducedSubTree ] ].
	^ aTree 
]

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> reduce: aTree using: aGrammar [

	| reducedSubTrees | 
	1 halt. 
	
	reducedSubTrees:= UmeSimplifyGrammarAlternateReduction findSubtree: aTree with: aGrammar  .
	reducedSubTrees ifNotNil: [ ^ reducedSubTrees ].
	
	^ nil
]
