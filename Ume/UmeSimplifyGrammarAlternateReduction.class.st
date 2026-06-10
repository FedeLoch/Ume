Class {
	#name : 'UmeSimplifyGrammarAlternateReduction',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> alternateReduction: aTree [ 
	" return all the reduction candidates"
	| symbol expansions reductions  grammar|
	 
	reductions := OrderedCollection new.
	expansions := OrderedCollection new.
	symbol := aTree tag.
	grammar := aTree grammarRule fragments.
	
	grammar do: [ :aRule | expansions addAll: aRule rules ].
	expansions := expansions sorted: [ :expA :expB | expA fragments size < expB fragments size ]. 

	expansions do: [ :expansion | | match newChildReductions |
		match := true.
		newChildReductions := OrderedCollection new.
		expansion fragments do: [ :altSymbol | | childReductions|
			childReductions := UmeSimplifyGrammarSubtreeReducer findSubtree: aTree mathchingWith: altSymbol name.
			childReductions ifEmpty: [ match:= false ].
			match ifTrue: [ newChildReductions add: childReductions ]].
			1 halt.
		match ifTrue: [ (self possibleCombination: newChildReductions) do: [ :combination | |newTree|
				newTree := aTree class new.
				newTree tag: symbol.
				1 halt.
				newTree children: combination.
				1 halt.
				newTree treeSize  < aTree treeSize ifTrue: [ reductions add: newTree ].
				]
			]
		].
    ^ reductions sorted: [ :treeA :treeB | treeA treeSize  < treeB treeSize ]
]

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> alternateReduction: aTree using: aGrammar [
	" return all the reduction candidates"
	| symbol expansions reductions  grammar|
	 
	reductions := OrderedCollection new.
	expansions := OrderedCollection new.
	symbol := aTree tag.
	grammar := aTree grammarRule fragments.
	
	grammar do: [ :aRule | expansions addAll: aRule rules ].
	expansions := expansions sorted: [ :expA :expB | expA fragments size < expB fragments size ]. 

	expansions do: [ :expansion | | match newChildReductions |
		match := true.
		newChildReductions := OrderedCollection new.
		expansion fragments do: [ :altSymbol | | childReductions|
			childReductions := UmeSimplifyGrammarSubtreeReducer findSubtree: aTree mathchingWith: altSymbol name.
			childReductions ifEmpty: [ match:= false ].
			match ifTrue: [ newChildReductions add: childReductions ]].
			1 halt.
		match ifTrue: [ (self possibleCombination: newChildReductions) do: [ :combination | |newTree|
				1 halt. 
				newTree := UmeGrammarParser parse: combination asInput from: aGrammar .
				newTree treeSize  < aTree treeSize ifTrue: [ reductions add: newTree ].
				]
			]
		].
    ^ reductions sorted: [ :treeA :treeB | treeA treeSize  < treeB treeSize ]
]

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarAlternateReduction class >> findTarget: aNode [

	^ (aNode parent isNotNil and: [ ( aNode allNodes detect: [ :next |  next ~= aNode and: [ next tag = aNode tag ]] ifNone: [nil]) isNotNil. ])
]

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarAlternateReduction class >> possibleCombination: aListOfLists [

	| allCombinationsList |
	
	allCombinationsList := OrderedCollection new.
	aListOfLists ifNil: [ ^nil ].
	aListOfLists ifEmpty: [ ^ allCombinationsList ].
	
	
	allCombinationsList := OrderedCollection with: OrderedCollection new.
	aListOfLists do: [ :aSubList | |res|
		res := OrderedCollection new.
		allCombinationsList do: [ :combinations | 
			aSubList do: [ :element |
				res add: (combinations copy add: element); yourself ]
			].
		allCombinationsList := res.
		].
	^ allCombinationsList 

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
	
	treeCopy := self copyTree: aTree with: aGrammar.
	
	targetIndex := aTree allNodes findFirst: [ :subtree |
		(subtree isLeaf not) and: (subtree == aSubTree ) ].
	
	 
	(targetIndex = 0) ifTrue: [ ^ treeCopy ].
	
 	allNodesCopy := treeCopy allNodes.
	targetNodeInCopy := allNodesCopy at: targetIndex.   
	replacementNodeInCopy := self copyTree: aSubTree with: aGrammar. 
	^ targetNodeInCopy parent ifNil: [ replacementNodeInCopy ] ifNotNil: [ :parent | parent replaceChild: targetNodeInCopy with: replacementNodeInCopy. treeCopy ].
]
