Class {
	#name : 'UmeSimplifyGrammarBoth',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> reduce: subtree using: grammar matching: symbol depth: depth [ 
    
   | candidatesSubtree candidatesAlternate candidates|
    
   candidates := OrderedCollection new.
   candidatesAlternate := UmeSimplifyGrammarAlternateReduction alternateReduction: subtree using: grammar matchingWith: symbol depth: depth .

	candidatesSubtree := UmeSimplifyGrammarSubtreeReducer findSubtree: subtree mathchingWith: symbol depth: depth.
	candidates := candidatesSubtree, candidatesAlternate.

	^ candidates 
]
