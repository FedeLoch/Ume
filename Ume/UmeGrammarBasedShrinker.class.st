Class {
	#name : 'UmeGrammarBasedShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'minimalGenerator'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

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
UmeGrammarBasedShrinker >> grammar: aGrammar [

	super grammar: aGrammar.
	minimalGenerator grammar: aGrammar
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> initialize [ 
	
	super initialize.
	minimalGenerator := GrammarMinimalGenerator new.
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
			"TODO: this could be donde by saving in a memo all the nodes that are not available anymore"
			(parent notNil and: [ allNodes includes: candidate ]) ifTrue: [ | index |
				index := parent children indexOf: candidate.
				"trying to minimize a candidate"
				parent replaceChildAt: index with: (self minimized: candidate).
				self minimizationDone.
				
				trigger := self triggerBug: (self evalInput: tree asInput) upperBound: upperBound.
				((self isValidTree: tree) and: [ trigger ]) ifFalse: [
					self failedMinimization.
					parent replaceChildAt: index with: candidate.
					"trying to replace the parent by candidate in case they have the same symbol"
					(parent tag = candidate tag) ifTrue: [ | parentChildren candidateChildren |
						parentChildren := parent children.
						candidateChildren := candidate children.
						parent children: candidateChildren.
						self minimizationDone.
						
						trigger := self triggerBug: (self evalInput: tree asInput) upperBound: upperBound.
						((self isValidTree: tree) and: [ trigger ]) ifFalse: [
							self failedMinimization.
							parent children: parentChildren.
							candidate children: candidateChildren.
						]
					]
				].
		 	]
		]
	].

	^ tree 
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> minimized: node [

	^ node grammarRule visit: minimalGenerator
]

{ #category : 'testing' }
UmeGrammarBasedShrinker >> triggerBug: evalResult upperBound: originalScore [

	^ oracle accepts: evalResult from: originalScore
]
