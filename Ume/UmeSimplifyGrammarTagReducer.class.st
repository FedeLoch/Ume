Class {
	#name : 'UmeSimplifyGrammarTagReducer',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarTagReducer class >> reduce: aTree [

	^ ( UmeSimplifyGrammarAlternateReduction reduce:( UmeSimplifyGrammarSubtreeReducer reduce: aTree )). 
]
