Class {
	#name : 'UmeSimplifyGrammarSubtreeReducer',
	#superclass : 'Object',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarSubtreeReducer class >> reduce: aTree [

	| allNodes |
	
	allNodes := aTree allNodes. 
	allNodes do: [ :node |
		| parent matchingSymbol matchingNodes |
		parent:= node parent.
		matchingSymbol := node getMatchingSymbol. "get the symbol who match this node"
		"we want to look into the subtree for node who match this one"
		matchingNodes := self getMatchigNodesFor: matchingSymbol.
	]
]
