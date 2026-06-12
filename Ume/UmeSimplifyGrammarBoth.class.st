Class {
	#name : 'UmeSimplifyGrammarBoth',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> findCandidates: aTree using: aGrammar matchingWith: aSymbol [

	| candidatesSubtree candidatesAlternate candidates|
	
	candidates := OrderedCollection new.
	 
	candidatesAlternate := (UmeSimplifyGrammarAlternateReduction alternateReduction: aTree using: aGrammar matchingWith: aSymbol ).
	candidatesSubtree := (UmeSimplifyGrammarSubtreeReducer findSubtree: aTree mathchingWith: aSymbol ).
	candidates := candidatesSubtree, candidatesAlternate.  
	
	^ candidates 
]
