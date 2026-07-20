Class {
	#name : 'UmeRandomMutatorSelector',
	#superclass : 'UmeMutatorSelector',
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'accessing' }
UmeRandomMutatorSelector >> mutatorWeights [ 

	^ corpusGenerator mutators collect: #weight
]

{ #category : 'enumerating' }
UmeRandomMutatorSelector >> selectMutator: mutators [

	^ mutators atRandom
]
