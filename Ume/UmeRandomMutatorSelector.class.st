Class {
	#name : 'UmeRandomMutatorSelector',
	#superclass : 'UmeMutatorSelector',
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'enumerating' }
UmeRandomMutatorSelector >> select: mutators [

	^ mutators atRandom
]
