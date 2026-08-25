Class {
	#name : 'UmeIdentifierReplacement',
	#superclass : 'UmeVulcanAuxiliaryReducer',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeIdentifierReplacement >> reduce: aTree bound: bound [

	| leaves |
	leaves := aTree allNodes select: #isLeaf.
	
	"complexity:
	1. searching for all the leaves in the tree => O(n)
	2. iterating over the first and second list of L leaves => O(L^2)
	3. complexity of the method (without looking at triggerBug => O(n+L^2)"
	
	leaves do: [ :leaf |
		leaves do: [ :leafToReplace | 
			"searching for another leaf with the same symbol"
			((leafToReplace ~= leaf) and: [leafToReplace parent tag == leaf parent tag]) ifTrue: [ | previousToken |
				"replacing the found leaf symbol by the first one"
				previousToken := leafToReplace token.
				leafToReplace token: leaf token.
				self minimizationDone.
				( self triggerBug: aTree upperBound: bound ) ifFalse: [
					"if the previous replacement stop the trigger of the bug, we rollback "
					leafToReplace token: previousToken.
					self failedMinimization.
				]
			]
		]
	].		
				
	^ aTree 
]
