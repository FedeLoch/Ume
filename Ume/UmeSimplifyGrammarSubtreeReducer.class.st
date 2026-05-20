Class {
	#name : 'UmeSimplifyGrammarSubtreeReducer',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> copyTree: aTree with: aGrammar [

	^ UmeGrammarParser parse: (aTree asInput ) from: aGrammar
]

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> findCandidates: aTree using: aGrammar [

	| candidates |
	
	candidates := OrderedCollection new. 
	
	aTree allNodes doWithIndex: [ :node :index |
		(node parent isNotNil and: [ node isLeaf not and: [ node parent tag = node tag ] ]) ifTrue: [ 
			| treeCopy allNodesCopy theOne |
			treeCopy := self copyTree: aTree with: aGrammar . 
			allNodesCopy := treeCopy allNodes.
			theOne := allNodesCopy at: index.
			theOne grandParent replaceChild: (theOne parent) with: theOne. 
			candidates add: treeCopy. 
		 ]
	].

	^ candidates
]

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> findCandidatesFor: aSubTree using: aGrammar [

	| candidates |
	
	candidates := OrderedCollection new. 
	
	aSubTree allNodes doWithIndex: [ :node :index |
		(node parent isNotNil and: [ node isLeaf not and: [ node parent tag = node tag ] ]) ifTrue: [ 
			| treeCopy allNodesCopy theOne |
			treeCopy := self copyTree: aSubTree with: aGrammar . 
			allNodesCopy := treeCopy allNodes.
			theOne := allNodesCopy at: index.
			theOne grandParent replaceChild: (theOne parent) with: theOne. 
			candidates add: treeCopy. 
		 ]
	].

	^ candidates
]

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> reduce: aTree [
	"subtree reductions"
	| allNodes theOne theOneIndex |
	
	allNodes := aTree allNodes.
	
	theOneIndex := allNodes findFirst: [ :node |
		node parent isNotNil and: [ node isLeaf not and: [ node parent tag = node tag ] ]
	].

	theOneIndex = 0 ifTrue: [ ^ nil ]. 
	
	theOne := allNodes at: theOneIndex.

	theOne grandParent replaceChild: (theOne parent) with: theOne.

	^ aTree
]
