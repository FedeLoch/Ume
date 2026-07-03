Class {
	#name : 'UmeGraphCodeParserGenerator',
	#superclass : 'UmeParserGenerator',
	#category : 'Ume-Generators',
	#package : 'Ume',
	#tag : 'Generators'
}

{ #category : 'as yet unclassified' }
UmeGraphCodeParserGenerator >> parse: grammarBasedInput [

	1 halt.
	^ grammarBasedInput lines collect: [ :assoc | self parseAssoc: assoc ]
]
