Class {
	#name : 'UmeSimplifyGrammarSubtreeReducer',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> reduce: aTree [

	| allNodes theOne theOneIndex |
	
	allNodes := aTree allNodes.
	
	theOneIndex := allNodes findFirst: [ :node |
		node parent isNotNil and: [ node isLeaf not and: [ node parent tag = node tag ] ]
	].
	
	theOne := allNodes at: theOneIndex.

	theOne grandParent replaceChild: (theOne parent) with: theOne.

	^ aTree
]
