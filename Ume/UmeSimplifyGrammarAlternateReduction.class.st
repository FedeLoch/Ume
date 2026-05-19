Class {
	#name : 'UmeSimplifyGrammarAlternateReduction',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

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

	| allNodes targetIndex targetNode replacementIndex replacementNode |
	
	allNodes := aTree allNodes .
	
	targetIndex := allNodes findFirst: [ :node | self findTarget: node  ].
	(targetIndex = 0) ifTrue: [ ^aTree ].
	targetNode := allNodes at: targetIndex.
	
	replacementIndex := targetNode allNodes findFirst: [ :next | self isRepleceable: next in: targetNode ].
	replacementNode := targetNode allNodes at: replacementIndex.
	
	
	targetNode parent replaceChild: targetNode with: replacementNode.
	^aTree. 
]
