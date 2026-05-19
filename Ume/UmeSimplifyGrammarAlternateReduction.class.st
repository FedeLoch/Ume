Class {
	#name : 'UmeSimplifyGrammarAlternateReduction',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> reduce: aTree [

	| allNodes targetIndex targetNode replacementIndex replacementNode |
	
	allNodes := aTree allNodes .
	
	targetIndex := allNodes findFirst: [ :node | node parent isNotNil and: [ ( node allNodes detect: [ :next |  next ~= node and: [ next tag = node tag ]] ifNone: [nil]) isNotNil. ] ].
	(targetIndex = 0) ifTrue: [ ^aTree ].
	targetNode := allNodes at: targetIndex.
	
	replacementIndex := targetNode allNodes findFirst: [ :next | next ~= targetNode and: [ next tag = targetNode tag ] ].
	replacementNode := targetNode allNodes at: replacementIndex.
	
	targetNode parent replaceChild: targetNode with: replacementNode.
	^aTree. 
]
