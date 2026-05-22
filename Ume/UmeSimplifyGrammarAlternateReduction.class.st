Class {
	#name : 'UmeSimplifyGrammarAlternateReduction',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> alternateReduction: aTree using: aGrammar [
	" return all the reduction candidates"
	| rules candidates reductions  |
	
	candidates := OrderedCollection new. 
	reductions := OrderedCollection new.
	rules := aTree grammarRule fragments .

	rules do: [ :rule | | match newChild validSubtrees |
		match := true.
		newChild := OrderedCollection new.
		validSubtrees := UmeSimplifyGrammarSubtreeReducer findSubtree: aTree mathchingWith: rule name.
		(validSubtrees isNil) ifTrue: [ match := false ].
		1 halt. 
		match ifTrue: [ 
			 validSubtrees do: [ :subtree | | newTree |
				newTree := self updateTree: aTree with: subtree using: aGrammar.
				1 halt. 
				( newTree treeSize ) < ( aTree treeSize) ifTrue: [ 
					reductions add: newTree ] ] ]  
		].
	1 halt. 
    ^ reductions sorted: [ :treeA :treeB | (treeA treeSize ) < (treeB treeSize ) ] 
]

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

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> updateTree: aTree with: aSubTree using: aGrammar [

	| treeCopy replacementNodeInCopy allNodesCopy allNodes targetIndex targetNodeInCopy|
	
	1 halt.
	treeCopy := self copyTree: aTree with: aGrammar.
	allNodes := aTree allNodes.
	targetIndex := allNodes identityIndexOf: aSubTree. 
	targetIndex = 0 ifTrue: [ ^ treeCopy ].
 	allNodesCopy := treeCopy allNodes.
	targetNodeInCopy := allNodesCopy at: targetIndex.   
	replacementNodeInCopy := self copyTree: aSubTree with: aGrammar. 
	1 halt. 
	targetNodeInCopy parent ifNil: [ ^ replacementNodeInCopy ] ifNotNil: [ :parent | parent replaceChild: targetNodeInCopy with: aSubTree . ].
   ^ treeCopy.
]
