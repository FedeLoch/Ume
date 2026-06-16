Class {
	#name : 'UmeGrammarBasedShrinker',
	#superclass : 'UmeGrammarShrinker',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> candidates: root [
	
	| worstReward worst |
	worstReward := SmallInteger maxVal.
	worst := OrderedCollection new.
	
	root allNodes do: [ :node | | reward |
		reward := node reward: grammar root: root.
		(reward < worstReward) ifTrue: [ worstReward := reward . worst := OrderedCollection new ].
		(reward = worstReward) ifTrue: [ worst add: node ]
	].

	^ worst
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> isValidTree: node [

	| input derivation |
	input := node asInput.

	[ derivation := self parse: input ] on: Error do: [ ^ false ].
	derivation ifNil: [ ^ false ].

	^ derivation asInput = input
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> minimizeOne: tree upperBound: upperBound [

	| seen allNodes |
	
	seen := Set new.
	allNodes := tree allNodes asSet.
	
	"TODO: We need to recompute the candidates each time we accept a new version of out tree input"
	(self candidates: tree) do: [ :candidate | | parent trigger |
		(seen includes: candidate) ifFalse: [
			seen add: candidate.
			parent := candidate parent.
			(parent notNil and: [ allNodes includes: candidate ]) ifTrue: [ | index |
				index := parent children indexOf: candidate.
				parent replaceChildAt: index with: candidate emptyTree.
				self minimizationDone.
				trigger := self triggerBug: (self evalInput: tree asInput) upperBound: upperBound.
				((self isValidTree: tree) and: [ trigger ]) ifFalse: [
					self failedMinimization.
					parent replaceChildAt: index with: candidate
				]
		 	]
		]
	].

	^ tree 
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> triggerBug: evalResult upperBound: originalScore [

"	score ifNil: [ ^ false ].

	^ score >= (originalScore * threshold)"

	^ oracle accepts: evalResult from: originalScore
]
