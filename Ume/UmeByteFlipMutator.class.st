Class {
	#name : 'UmeByteFlipMutator',
	#superclass : 'UmeStringMutator',
	#category : 'Ume-Mutators',
	#package : 'Ume',
	#tag : 'Mutators'
}

{ #category : 'accessing' }
UmeByteFlipMutator >> applyMutation: target [
	"Swaps two random characters. It works on a copy: the input may be a corpus element or a method literal"

	| at1 at2 temp mutated |
	
	target ifEmpty: [ ^ target ].
	
	mutated := target copy.
	at1 := mutated size atRandom.
	at2 := mutated size atRandom.

	temp := mutated at: at1.
	mutated at: at1 put: (mutated at: at2).
	mutated at: at2 put: temp.
	
	^ mutated
]
