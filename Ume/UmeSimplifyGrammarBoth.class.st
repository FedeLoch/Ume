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
UmeSimplifyGrammarBoth class >> reduce: aTree using: aGrammar [

	| candidates candidatesSubtree candidatesAlternate| 
	
	candidates := OrderedCollection new.
	 
	candidatesSubtree := (UmeSimplifyGrammarAlternateReduction findCandidates: aTree using: aGrammar).
	candidatesAlternate := (UmeSimplifyGrammarSubtreeReducer findCandidates: aTree using: aGrammar).
	candidates := candidatesSubtree, candidatesAlternate.  
	
	^ aTree 
]
