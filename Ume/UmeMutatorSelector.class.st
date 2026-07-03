Class {
	#name : 'UmeMutatorSelector',
	#superclass : 'Object',
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'feedback' }
UmeMutatorSelector >> feed: feedback [
	"Do nothing by default — subclasses can override to track feedback"
]

{ #category : 'enumerating' }
UmeMutatorSelector >> selectMutator: mutators [

	self subclassResponsibility 
]
