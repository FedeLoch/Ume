Class {
	#name : 'UmeMutatorSelector',
	#superclass : 'Object',
	#instVars : [
		'corpusGenerator'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'accessing' }
UmeMutatorSelector >> corpusGenerator: Acorpus [

	corpusGenerator := Acorpus
]

{ #category : 'feedback' }
UmeMutatorSelector >> feed: feedback [
	
	(corpusGenerator lastSelectedMutator isNil or: [ feedback isNil ]) ifTrue: [ ^ nil ].

	feedback isPositive
		ifTrue: [ corpusGenerator lastSelectedMutator increaseWeight ]
		ifFalse: [ "corpusGenerator lastSelectedMutator decreaseWeight" ] "We should not reduce the weight in negative case."
]

{ #category : 'accessing' }
UmeMutatorSelector >> lastMutatedSelector [

	^ corpusGenerator mutators indexOf: corpusGenerator lastSelectedMutator
]

{ #category : 'accessing' }
UmeMutatorSelector >> lastSelectedIndex [

	^ corpusGenerator mutators indexOf: corpusGenerator lastSelectedMutator
]

{ #category : 'accessing' }
UmeMutatorSelector >> mutatorWeights [

	self subclassResponsibility 
]

{ #category : 'enumerating' }
UmeMutatorSelector >> selectMutator: mutators [

	self subclassResponsibility 
]
