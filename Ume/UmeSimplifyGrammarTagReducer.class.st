Class {
	#name : 'UmeSimplifyGrammarTagReducer',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarTagReducer class >> alternateReducuction: aTree [

	
]

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarTagReducer class >> findSubtrees: aTree [

	| subtrees |
	
	subtrees := OrderedCollection new.
	aTree allNodes do: [ :node |
		(node parent isNotNil and: [ node isLeaf not and: [ aTree tag = node tag ] ]) ifTrue: [subtrees add: node]
	].
]

{ #category : 'enumerating' }
UmeSimplifyGrammarTagReducer class >> reduce: aTree [

	^ ( UmeSimplifyGrammarAlternateReduction reduce:( UmeSimplifyGrammarSubtreeReducer reduce: aTree )). 
]
