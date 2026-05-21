Class {
	#name : 'UmeSimplifyGrammarAlternateReduction',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> findCandidates: aTree using: aGrammar [
	" return all the reduction candidates"
	| candidates |
	
	candidates := OrderedCollection new. 
	
	aTree allNodes doWithIndex: [ :node :index | 
		(self findTarget: node) ifTrue: [ 
			node allNodes doWithIndex: [ :nodeSon :sonIndex| 
				(self isRepleceable: nodeSon in: node ) ifTrue: [ 
					| treeCopy allNodesCopy targetNode replacementNode |
					treeCopy := self copyTree: aTree with: aGrammar .
					allNodesCopy := treeCopy allNodes.
					targetNode := allNodesCopy at: index. 
					replacementNode := targetNode allNodes at: sonIndex.
					targetNode parent replaceChild: targetNode with: replacementNode. 
				]
			] 
		] 
	].

	^ candidates 
]

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> findSubtree: aTree with: aGrammar [ 
	" return all the reduction candidates"
	| reduction |
	
	reduction := OrderedCollection new. 
	
	aTree allNodes doWithIndex: [ :node :index | 
		| reductionCandidates |
		reductionCandidates := UmeSimplifyGrammarSubtreeReducer findSubtree: aTree mathchingWith: node.
		reductionCandidates do: [ :subtree | | treeCopy allNodesCopy targetNode |
			1 halt. 
			treeCopy := self copyTree: aTree with: aGrammar .
			allNodesCopy := treeCopy allNodes.
			targetNode := allNodesCopy at: index. 
			treeCopy replaceChild: targetNode with: subtree.
			reduction add: treeCopy. ]
			].

	^ reduction 
]

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarAlternateReduction class >> findTarget: aNode [

	^ (aNode parent isNotNil and: [ ( aNode allNodes detect: [ :next |  next ~= aNode and: [ next tag = aNode tag ]] ifNone: [nil]) isNotNil. ])
]

{ #category : 'testing' }
UmeSimplifyGrammarAlternateReduction class >> isRepleceable: aNode in: aTree [

	^(aNode ~= aTree and: [ aNode tag = aTree tag ])
]

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> reduce: aTree [
	"alternate reduction"
	| allNodes targetIndex targetNode replacementIndex replacementNode |
	
	allNodes := aTree allNodes .
	
	targetIndex := allNodes findFirst: [ :node | (node isLeaf not) and: [self findTarget: node]  ].
	(targetIndex = 0) ifTrue: [ ^ nil ].
	targetNode := allNodes at: targetIndex.
	
	replacementIndex := targetNode allNodes findFirst: [ :next | self isRepleceable: next in: targetNode ].
	replacementNode := targetNode allNodes at: replacementIndex.
	
	targetNode parent replaceChild: targetNode with: replacementNode.
	^ aTree 
]
