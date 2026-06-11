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
	| symbol expansions reductions  grammar|
	 
	reductions := OrderedCollection new.
	expansions := OrderedCollection new.
	symbol := aTree tag.
	grammar := aTree grammarRule fragments. 
	grammar do: [ :aRule | expansions addAll: aRule rules ]. 
	
	expansions := aTree grammarRule fragments. 
	expansions := expansions sorted: [ :expA :expB | expA fragments size < expB fragments size ]. 

	expansions do: [ :expansion | | match newChildReductions |
		match := true.
		newChildReductions := OrderedCollection new.
		expansion fragments do: [ :altSymbol | | childReductions|
			childReductions := UmeSimplifyGrammarSubtreeReducer findSubtree: aTree mathchingWith: altSymbol.
			childReductions ifEmpty: [ match:= false ].
			match ifTrue: [ newChildReductions add: childReductions ]].
		match ifTrue: [ (self possibleCombination: newChildReductions) do: [ :combination | |newTree|
				newTree := aTree class new. 
				newTree tag: symbol .
				newTree children: combination. 
				newTree treeSize  < aTree treeSize ifTrue: [ reductions add: newTree ].
				]
			]
		].
    ^ reductions sorted: [ :treeA :treeB | treeA treeSize  < treeB treeSize ]
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

{ #category : 'enumerating' }
UmeSimplifyGrammarAlternateReduction class >> reduce: aTree using: aGrammar [
	"alternate reduction"
	
	| res |
	
	res := self alternateReduction: aTree using: aGrammar. 
	^ res ifNil: [ ^ aTree ] ifNotNil: [ ^ res ]
]
