Class {
	#name : 'UmeMOPTMutatorSelector',
	#superclass : 'UmeMutatorSelector',
	#instVars : [
		'mopt'
	],
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'feedback' }
UmeMOPTMutatorSelector >> feed: feedback [

	mopt feed: feedback
]

{ #category : 'initialization' }
UmeMOPTMutatorSelector >> initialize [

	mopt := UmeMOPT new
]

{ #category : 'accessing' }
UmeMOPTMutatorSelector >> mutatorWeights [
	"This may be called before the mopt is initialized??"

	mopt ifNil: [ ^ nil ].
	mopt swarms ifNil: [ ^ nil ].
	^ mopt bestSwarm probabilities
]

{ #category : 'enumerating' }
UmeMOPTMutatorSelector >> selectMutator: mutators [

	^ mopt selectCandidate: mutators
]
