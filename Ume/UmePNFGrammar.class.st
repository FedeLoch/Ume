Class {
	#name : 'UmePNFGrammar',
	#superclass : 'Object',
	#instVars : [
		'start',
		'nonTerminals',
		'parameters'
	],
	#category : 'Ume-PNF',
	#package : 'Ume',
	#tag : 'PNF'
}

{ #category : 'accessing' }
UmePNFGrammar >> eachNonTerminal: body [

	nonTerminals do: [ :nt | body value: nt ]
]

{ #category : 'accessing' }
UmePNFGrammar >> initialize [

	super initialize.
	parameters := OrderedCollection new.
	nonTerminals := OrderedCollection new
]

{ #category : 'accessing' }
UmePNFGrammar >> minHeight [

	^ start minHeight
]

{ #category : 'accessing' }
UmePNFGrammar >> minSize [

	^ start minSize
]

{ #category : 'accessing' }
UmePNFGrammar >> nonTerminals [

	^ nonTerminals
]

{ #category : 'accessing' }
UmePNFGrammar >> nonTerminals: collection [

	nonTerminals := collection
]

{ #category : 'accessing' }
UmePNFGrammar >> parameters [

	^ parameters
]

{ #category : 'printing' }
UmePNFGrammar >> printOn: stream [

	stream << 'PNF Grammar ('.
	stream print: nonTerminals size.
	stream << ' non-terminals)'.
	OSPlatform current lineEnding on: stream.
	self eachNonTerminal: [ :nt |
		stream print: nt.
		stream << OSPlatform current lineEnding ]
]

{ #category : 'accessing' }
UmePNFGrammar >> start [

	^ start
]

{ #category : 'accessing' }
UmePNFGrammar >> start: aNonTerminal [

	start := aNonTerminal
]

{ #category : 'accessing' }
UmePNFGrammar >> terminals [

	| n |
	n := Set new.
	self eachNonTerminal: [ :e | n addAll: e terminals ].
	^ n
]
