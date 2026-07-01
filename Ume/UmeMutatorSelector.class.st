Class {
	#name : 'UmeMutatorSelector',
	#superclass : 'Object',
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'enumerating' }
UmeMutatorSelector >> select: mutators [

	self subclassResponsibility 
]

{ #category : 'feedback' }
UmeMutatorSelector >> feed: feedback [
	"Do nothing by default — subclasses can override to track feedback"
]
