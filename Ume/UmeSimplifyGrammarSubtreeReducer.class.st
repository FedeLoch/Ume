Class {
	#name : 'UmeSimplifyGrammarSubtreeReducer',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> findSubtree: aTree mathchingWith: aSymbol [
	" return all the reduction candidates based on a symbol"
	| candidates |
	
	candidates := OrderedCollection new. 
	aTree isLeaf ifTrue: [ ^candidates ].
	
	aTree children do: [ :node  |
		(node parent isNotNil and: [ node isLeaf not and: [ aSymbol = node tag ] ]) ifTrue: [ 
			candidates add: node. 
		 ].
		node isLeaf ifFalse: [ candidates addAll: (self findSubtree: node mathchingWith: aSymbol ) ]
	].

	

	^ candidates
]

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> findSubtreesIndex: aTree mathchingWith: aSymbol [
	" return all the reduction candidates index based on a symbol"
	| candidates |
	
	candidates := OrderedCollection new. 
	
	aTree allNodes doWithIndex: [ :node :index |
		(node parent isNotNil and: [ node isLeaf not and: [ aSymbol = node tag ] ]) ifTrue: [ 
			candidates add: index. 
		 ]
	].


	^ candidates
]

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> reduce: subtree using: grammar matching: symbol [

	^ self findSubtree: subtree mathchingWith: symbol 

]
