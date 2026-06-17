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
UmeGrammarBasedShrinker >> minimizeOne: givenTree upperBound: upperBound [

	| seen candidates tree |

	seen := Set new.
	tree := self tree: givenTree asInput.
	candidates := self candidates: tree.

	[ candidates isNotEmpty ] whileTrue: [ | candidate parent |
		candidate := candidates first.
		candidates := candidates allButFirst.
		(seen includes: candidate asInput) ifFalse: [
			seen add: candidate asInput.
			parent := candidate parent.

			parent notNil ifTrue: [ | index |
				index := parent children indexOf: candidate.
				"trying to minimize a candidate"
				parent replaceChildAt: index with: (self minimized: candidate).
				self minimizationDone.
				
				(self triggerBug: tree upperBound: upperBound) ifFalse: [
					self failedMinimization.
					parent replaceChildAt: index with: candidate.
					
					"trying to replace the parent by candidate in case they have the same symbol"
					(parent tag = candidate tag) ifTrue: [ | parentChildren candidateChildren |
						parentChildren := parent children.
						candidateChildren := candidate children.

						parent children: candidateChildren.
						self minimizationDone.
						
						(self triggerBug: tree upperBound: upperBound) ifFalse: [	
							self failedMinimization.
							parent children: parentChildren.
							candidate children: candidateChildren.
						] ifTrue: []
					]
				] ifTrue: []
			]
		]
	].

	^ tree 
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> minimized: node [

	| newNode |
	
	newNode := node grammarRule visit: minimalGenerator.
	newNode tag: node	tag.
	newNode grammarRule: node grammarRule.

	^ newNode
]

{ #category : 'shrinking' }
UmeGrammarBasedShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized asInput = current asInput
]
