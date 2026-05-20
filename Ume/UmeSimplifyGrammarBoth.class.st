Class {
	#name : 'UmeSimplifyGrammarBoth',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarBoth class >> findCandidates: aTree using: aGrammar [

	| candidates |
	
	candidates := OrderedCollection new. 
	candidates add: (UmeSimplifyGrammarAlternateReduction findCandidates: aTree using: aGrammar).
	candidates add: (UmeSimplifyGrammarSubtreeReducer findCandidates: aTree using: aGrammar).
	
	^ candidates "il faut check si j'ai pas de doublons"
]
