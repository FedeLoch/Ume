Class {
	#name : 'MyUmeExampleProperty',
	#superclass : 'UmeProperty',
	#category : 'Ume-Property Schema',
	#package : 'Ume',
	#tag : 'Property Schema'
}

{ #category : 'as yet unclassified' }
MyUmeExampleProperty >> satisfies: aReceiver args: anArgs result: aResult [

	^ aResult > 0
]
