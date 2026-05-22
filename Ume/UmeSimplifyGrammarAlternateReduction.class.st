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
		match ifTrue: [ 
			 validSubtrees do: [ :subtree | | newTree |
				"newTree := self updateTree: aTree with: subtree using: aGrammar."
				newTree := self copyTree: subtree with: aGrammar.
				( newTree treeSize ) < ( aTree treeSize) ifTrue: [ 
					reductions add: newTree ] ] ]  
		].
    ^ reductions sorted: [ :treeA :treeB | (treeA treeSize ) < (treeB treeSize ) ] 
]

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarAlternateReduction class >> findTarget: aNode [

	^ (aNode parent isNotNil and: [ ( aNode allNodes detect: [ :next |  next ~= aNode and: [ next tag = aNode tag ]] ifNone: [nil]) isNotNil. ])
]

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> reduce: aTree [
	"alternate reduction"
	| allNodes targetIndex targetNode replacementIndex replacementNode |
	
	allNodes := aTree allNodes .
	
	targetIndex := allNodes findFirst: [ :node | (node isLeaf not) and: [self findTarget: node] ].
	(targetIndex = 0) ifTrue: [ ^ nil ].
	targetNode := allNodes at: targetIndex.
	
	replacementIndex := targetNode allNodes findFirst: [ :next | self isRepleceable: next in: targetNode ].
	replacementNode := targetNode allNodes at: replacementIndex.
	
	targetNode parent replaceChild: targetNode with: replacementNode.
	^ aTree 
]

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> reduce: aTree using: aGrammar [
	"alternate reduction"
	
	| res |
	
	res := self alternateReduction: aTree using: aGrammar. 
	^ res ifNil: [ ^ aTree ] ifNotNil: [ ^ res ]
]

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> updateTree: aTree with: aSubTree using: aGrammar [

	| treeCopy replacementNodeInCopy allNodesCopy targetIndex targetNodeInCopy|
	
	1 halt.
	treeCopy := self copyTree: aTree with: aGrammar.
	
	targetIndex := aTree allNodes findFirst: [ :subtree |
		1 halt.(subtree isLeaf not) and: (subtree == aSubTree ) ].
	
	 
	(targetIndex = 0) ifTrue: [ ^ treeCopy ].
	
 	allNodesCopy := treeCopy allNodes.
	targetNodeInCopy := allNodesCopy at: targetIndex.   
	replacementNodeInCopy := self copyTree: aSubTree with: aGrammar. 
	1 halt. 
	^ targetNodeInCopy parent ifNil: [ replacementNodeInCopy ] ifNotNil: [ :parent | parent replaceChild: targetNodeInCopy with: replacementNodeInCopy. treeCopy ].
]
