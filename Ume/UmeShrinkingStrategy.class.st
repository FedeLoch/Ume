Class {
	#name : 'UmeShrinkingStrategy',
	#superclass : 'Object',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'copying' }
UmeShrinkingStrategy class >> copyTree: aTree [

	^ aTree doCopy. 
]

{ #category : 'enumerating' }
UmeShrinkingStrategy class >> reduce: subtree using: grammar matching: symbol [

	self subclassResponsibility 
]
