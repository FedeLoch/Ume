Class {
	#name : 'UmeIdentifierReplacement',
	#superclass : 'UmeVulcanAuxiliaryReducer',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeIdentifierReplacement >> reduce: aTree bound: bound [

	| allLeaf |
	allLeaf := OrderedCollection new.
	aTree allNodes do: [ :node | (node isLeaf) ifTrue: [ allLeaf add: node ] ].
	
	allLeaf do: [ :leaf |
		allLeaf do: [ :leafToReplace | 
			(leafToReplace parent tag == leaf parent tag) ifTrue: [ | previousToken |
				previousToken := leafToReplace token.
				leafToReplace token: leaf token.
				self minimizationDone.
				( self triggerBug: aTree upperBound: bound ) ifFalse: [
					leafToReplace token: previousToken.
					self failedMinimization.
				]
			]
		]
	].
				
				
	^ aTree 
]
