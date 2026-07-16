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
UmeSimplifyGrammarSubtreeReducer class >> findSubtree: aTree mathchingWith: aSymbol depth: depth [

	" return all the reduction candidates based on a symbol"
	| candidates |
	
	candidates := OrderedCollection new. 
	aTree isLeaf ifTrue: [ ^candidates ].
	
	aTree children do: [ :node  |
		((depth <= 0) and: (node parent isNotNil and: [ node isLeaf not and: [ aSymbol = node tag ] ])) ifTrue: [
			candidates add: node ].

		((depth ~= 0) and: (node isLeaf not)) ifTrue: [
			candidates addAll: (self findSubtree: node mathchingWith: aSymbol  depth: depth - 1 ) ]
	].

	^ candidates
]

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> reduce: subtree using: grammar matching: symbol depth: depth [

	^ self findSubtree: subtree mathchingWith: symbol depth: depth 

]
