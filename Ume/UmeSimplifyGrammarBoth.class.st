Class {
	#name : 'UmeSimplifyGrammarBoth',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> reduce: subtree using: grammar matching: symbol [
    
   | candidatesSubtree candidatesAlternate candidates|
    
   candidates := OrderedCollection new.
   candidatesAlternate := UmeSimplifyGrammarAlternateReduction alternateReduction: subtree using: grammar matchingWith: symbol.

	candidatesSubtree := UmeSimplifyGrammarSubtreeReducer findSubtree: subtree mathchingWith: symbol.
	candidates := candidatesSubtree, candidatesAlternate.

	^ candidates sorted: [ :treeA :treeB | treeA treeSize  < treeB treeSize ]
]
