Class {
	#name : 'UmeSimplifyGrammarAlternateReduction',
	#superclass : 'UmeShrinkingStrategy',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> alternateReduction: aTree using: aGrammar matchingWith: symbol [
	" return all the reduction candidates"
	| expansions reductions nonTerminal |

	reductions := OrderedCollection new.
	nonTerminal := aGrammar instVarNamed: ('nt' , symbol asString).
	expansions := nonTerminal rules.
	expansions := expansions sorted: [ :expA :expB | expA fragments size < expB fragments size ]. 
	
	expansions do: [ :expansion | | match newChildReductions |
		match := true.
		newChildReductions := OrderedCollection new.
		expansion fragments do: [ :altSymbol | | childReductions treeCopy | 
			(altSymbol isTerminal ) ifFalse: [ 
			treeCopy := aTree doCopy. 
			childReductions := UmeSimplifyGrammarSubtreeReducer findSubtree: treeCopy mathchingWith: altSymbol name. 
			childReductions ifEmpty: [ match:= false ].
			match ifTrue: [ newChildReductions add: childReductions ]  ]
		].
		match ifTrue: [ (self possibleCombination: newChildReductions) do: [ :combination | | newTree|
				newTree := self buildNewTree: combination tag: symbol.
				newTree treeSize  < aTree treeSize ifTrue: [ reductions add: newTree ].
				]
			]
		].
    ^ reductions
]

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> buildNewTree: aCombination tag: aSymbol [
	
	| newSubTree |
	
	newSubTree := GncInnerNode new.
	newSubTree tag: aSymbol.
	newSubTree children: aCombination.
	
	^ newSubTree
]

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarAlternateReduction class >> possibleCombination: aListOfLists [

	| allCombinationsList |
	
	aListOfLists ifNil: [ ^nil ].
	aListOfLists ifEmpty: [ ^ OrderedCollection new ].
	allCombinationsList := OrderedCollection with: OrderedCollection new.
	
	aListOfLists do: [ :aSubList | |res|
		res := OrderedCollection new.
		allCombinationsList do: [ :combinations | 
			aSubList do: [ :element |
				res add: (combinations copy add: element; yourself )]
			].
		allCombinationsList := res.
		].
	^ allCombinationsList 
]

{ #category : 'as yet unclassified' }
UmeSimplifyGrammarAlternateReduction class >> reduce: subtree using: grammar matching: symbol [

	^ self alternateReduction: subtree using: grammar matchingWith: symbol
]
