Class {
	#name : 'UmePNFConverter',
	#superclass : 'Object',
	#instVars : [
		'grammarMap',
		'startName',
		'ntCounter'
	],
	#category : 'Ume-PNF',
	#package : 'Ume',
	#tag : 'PNF'
}

{ #category : 'converting' }
UmePNFConverter >> buildGrammar [

	| ntDict grammar |
	ntDict := Dictionary new.
	grammarMap keysDo: [ :name |
		ntDict at: name put: (GncNonTerminal withName: name) ].
	grammarMap keysAndValuesDo: [ :name :rules |
		| nt |
		nt := ntDict at: name.
		rules do: [ :rule |
			| currentRule |
			currentRule := nt newRule.
			rule do: [ :symbol |
				(symbol isString)
					ifTrue: [ currentRule addFragment: (ntDict at: symbol) ]
					ifFalse: [ currentRule addFragment: symbol ] ] ] ].
	ntDict values do: [ :nt | nt seal ].
	grammar := UmePNFGrammar new.
	grammar start: (ntDict at: startName).
	grammar nonTerminals: ntDict values asArray.
	self computeCost: grammar.
	^ grammar
]

{ #category : 'collecting' }
UmePNFConverter >> collectFrom: aNonTerminal [

	| ntName |
	ntName := aNonTerminal name.
	(grammarMap includesKey: ntName) ifTrue: [ ^ self ].
	grammarMap at: ntName put: (aNonTerminal rules collect: [ :rule |
		rule fragments collect: [ :fragment |
			self symbolFor: fragment ] ]).
	aNonTerminal rules do: [ :rule |
		rule fragments do: [ :fragment |
			(fragment isKindOf: GncNonTerminal) ifTrue: [
				self collectFrom: fragment ] ] ]
]

{ #category : 'collecting' }
UmePNFConverter >> collectGrammar: aGrammar [

	grammarMap := Dictionary new.
	startName := aGrammar start name.
	self collectFrom: aGrammar start
]

{ #category : 'converting' }
UmePNFConverter >> computeCost: grammar [

	| again |
	again := false.
	{ GncMinHeightComputer new. GncMinSizeComputer new } do: [ :visitor |
		grammar start visit: visitor.
		again := again | visitor changed ].
	^ again
]

{ #category : 'preprocessing' }
UmePNFConverter >> preprocess [

	grammarMap keysAndValuesDo: [ :name :rules |
		grammarMap at: name put: ((rules collect: [ :rule |
			rule reject: [ :sym |
				(sym isKindOf: GncTerminalLiteral) and: [ sym literal isEmpty ] ] ]) reject: [ :r | r isEmpty ]) asArray ]
]

{ #category : 'epsilon elimination' }
UmePNFConverter >> eliminateEpsilonProductions [

	| nullable newGrammarMap |
	nullable := self findNullable.
	newGrammarMap := Dictionary new.
	grammarMap keysAndValuesDo: [ :name :rules |
		| newRules |
		newRules := OrderedCollection new.
		rules do: [ :rule |
			(self isEpsilonRule: rule nullable: nullable) ifFalse: [
				| variants |
				variants := self expandRule: rule nullable: nullable.
				newRules addAll: variants ] ].
		newGrammarMap at: name put: (newRules reject: [ :r | r isEmpty ]) asArray ].
	grammarMap := newGrammarMap
]

{ #category : 'epsilon elimination' }
UmePNFConverter >> expandRule: rule nullable: nullable [

	| result |
	result := OrderedCollection new.
	self expandRule: rule at: 1 current: OrderedCollection new nullable: nullable to: result.
	^ result
]

{ #category : 'epsilon elimination' }
UmePNFConverter >> expandRule: rule at: index current: current nullable: nullable to: result [

	| sym |
	index > rule size ifTrue: [
		current isEmpty ifFalse: [ result add: current asArray ].
		^ self ].
	sym := rule at: index.
	(sym isString and: [ nullable includes: sym ])
		ifTrue: [
			self expandRule: rule at: index + 1 current: current nullable: nullable to: result.
			current add: sym.
			self expandRule: rule at: index + 1 current: current nullable: nullable to: result.
			current removeLast ]
		ifFalse: [
			current add: sym.
			self expandRule: rule at: index + 1 current: current nullable: nullable to: result.
			current removeLast ]
]

{ #category : 'epsilon elimination' }
UmePNFConverter >> findNullable [

	| nullable changed |
	nullable := Set new.
	changed := true.
	[ changed ] whileTrue: [
		changed := false.
		grammarMap keysAndValuesDo: [ :name :rules |
			(nullable includes: name) ifFalse: [
				rules do: [ :rule |
					(rule isEmpty or: [
						self isEpsilonRule: rule nullable: nullable ]) ifTrue: [
						nullable add: name.
						changed := true ] ] ] ] ].
	^ nullable
]

{ #category : 'GNF conversion' }
UmePNFConverter >> convertRuleTail: rule [

	| result terminalChain |
	result := OrderedCollection new.
	result add: rule first.
	terminalChain := OrderedCollection new.
	2 to: rule size do: [ :i |
		| sym |
		sym := rule at: i.
		sym isString
			ifTrue: [
				terminalChain notEmpty ifTrue: [
					| newNtName |
					newNtName := self freshNTName.
					grammarMap at: newNtName put: { terminalChain asArray , { sym } }.
					result add: newNtName.
					terminalChain := OrderedCollection new ]
				ifFalse: [ result add: sym ] ]
			ifFalse: [ terminalChain add: sym ] ].
	terminalChain notEmpty ifTrue: [
		| newNtName |
		newNtName := self freshNTName.
		grammarMap at: newNtName put: { terminalChain asArray }.
		result add: newNtName ].
	^ { result asArray }
]

{ #category : 'converting' }
UmePNFConverter >> convertGrammar: aGrammar [

	self collectGrammar: aGrammar.
	self preprocess.
	self eliminateEpsilonProductions.
	self eliminateUnitProductions.
	self eliminateLeftRecursion.
	self eliminateEpsilonProductions.
	self eliminateUnitProductions.
	self convertToGNF.
	^ self buildGrammar
]

{ #category : 'GNF conversion' }
UmePNFConverter >> convertToGNF [

	| changed |
	changed := true.
	[ changed ] whileTrue: [
		changed := false.
		grammarMap keys asArray do: [ :ntName |
			| newRules |
			newRules := OrderedCollection new.
			(grammarMap at: ntName) do: [ :rule |
				rule isEmpty ifTrue: [ newRules add: rule ]
				ifFalse: [
					(rule first isString)
						ifTrue: [
							changed := true.
							| firstNtRules |
							firstNtRules := grammarMap at: rule first ifAbsent: [ #() ].
							firstNtRules do: [ :fr |
								fr isEmpty ifTrue: [
									rule allButFirst ifNotEmpty: [ :tail |
										newRules add: tail ]
								] ifFalse: [
									newRules add: fr , rule allButFirst ] ] ]
						ifFalse: [
							(rule size > 1 and: [
								(2 to: rule size) anySatisfy: [ :i |
									(rule at: i) isString not ] ])
								ifTrue: [
									changed := true.
									newRules addAll: (self convertRuleTail: rule) ]
								ifFalse: [ newRules add: rule ] ] ] ] ].
			grammarMap at: ntName put: (newRules reject: [ :r | r isEmpty ]) asArray ] ]
]

{ #category : 'epsilon elimination' }
UmePNFConverter >> isEpsilonRule: rule nullable: nullable [

	^ rule allSatisfy: [ :aSymbol |
		self isNullable: aSymbol nullable: nullable ]
]

{ #category : 'epsilon elimination' }
UmePNFConverter >> isNullable: aSymbol nullable: nullable [

	aSymbol isString ifTrue: [ ^ nullable includes: aSymbol ].
	^ (aSymbol isKindOf: GncTerminalLiteral)
		and: [ aSymbol literal isEmpty ]
]

{ #category : 'unit elimination' }
UmePNFConverter >> isUnitProduction: rule [

	^ rule size = 1 and: [ rule first isString ]
]

{ #category : 'unit elimination' }
UmePNFConverter >> computeUnitPairs [

	| pairs changed |
	pairs := Dictionary new.
	grammarMap keysDo: [ :name |
		pairs at: name put: (Set with: name) ].
	changed := true.
	[ changed ] whileTrue: [
		changed := false.
		grammarMap keysAndValuesDo: [ :name :rules |
			rules do: [ :rule |
				(self isUnitProduction: rule) ifTrue: [
					| target |
					target := rule first.
					((pairs at: name) includes: target) ifFalse: [
						changed := true.
						(pairs at: name) addAll:
							(pairs at: target ifAbsent: [ Set with: target ]) ] ] ] ] ].
	^ pairs
]

{ #category : 'unit elimination' }
UmePNFConverter >> eliminateUnitProductions [

	| unitPairs newGrammarMap |
	unitPairs := self computeUnitPairs.
	newGrammarMap := Dictionary new.
	grammarMap keysAndValuesDo: [ :name :rules |
		| newRules |
		newRules := OrderedCollection new.
		rules do: [ :rule |
			(self isUnitProduction: rule) ifFalse: [ newRules add: rule ] ].
		(unitPairs at: name ifAbsent: [ #() ]) do: [ :b |
			b = name ifFalse: [
				(grammarMap at: b ifAbsent: [ #() ]) do: [ :bRule |
					(self isUnitProduction: bRule) ifFalse: [
						newRules add: bRule ] ] ] ].
		newGrammarMap at: name put: newRules asArray ].
	grammarMap := newGrammarMap
]

{ #category : 'left recursion elimination' }
UmePNFConverter >> eliminateDirectLeftRecursion: ntName [

	| rules leftRecursive other |
	rules := grammarMap at: ntName ifAbsent: [ #() ].
	leftRecursive := OrderedCollection new.
	other := OrderedCollection new.
	rules do: [ :rule |
		(rule notEmpty and: [ rule first = ntName ])
			ifTrue: [ leftRecursive add: rule allButFirst ]
			ifFalse: [ other add: rule ] ].
	leftRecursive isEmpty ifTrue: [ ^ self ].
	| newNtName |
	newNtName := self freshNTName.
	| newRules |
	newRules := OrderedCollection new.
	other do: [ :rule |
		newRules add: rule , { newNtName } ].
	grammarMap at: ntName put: newRules asArray.
	| newNtRules |
	newNtRules := OrderedCollection new.
	leftRecursive do: [ :alpha |
		newNtRules add: alpha , { newNtName } ].
	newNtRules add: #().
	grammarMap at: newNtName put: newNtRules asArray
]

{ #category : 'left recursion elimination' }
UmePNFConverter >> eliminateLeftRecursion [

	| orderedNt |
	orderedNt := grammarMap keys asArray.
	1 to: orderedNt size do: [ :i |
		| aiName |
		aiName := orderedNt at: i.
		1 to: i - 1 do: [ :j |
			| ajName |
			ajName := orderedNt at: j.
			self replaceIndirectLeftRecursion: aiName with: ajName ].
		self eliminateDirectLeftRecursion: aiName ]
]

{ #category : 'left recursion elimination' }
UmePNFConverter >> replaceIndirectLeftRecursion: aiName with: ajName [

	| rules ajRules newRules |
	rules := grammarMap at: aiName ifAbsent: [ #() ].
	ajRules := grammarMap at: ajName ifAbsent: [ #() ].
	newRules := OrderedCollection new.
	rules do: [ :rule |
		(rule notEmpty and: [ rule first = ajName ])
			ifTrue: [
				ajRules do: [ :ajRule |
					newRules add: ajRule , rule allButFirst ] ]
			ifFalse: [ newRules add: rule ] ].
	grammarMap at: aiName put: newRules asArray
]

{ #category : 'private' }
UmePNFConverter >> freshNTName [

	ntCounter := ntCounter + 1.
	^ 'T_PNF' , ntCounter asString
]

{ #category : 'initialization' }
UmePNFConverter >> initialize [

	super initialize.
	grammarMap := Dictionary new.
	startName := ''.
	ntCounter := 0
]

{ #category : 'accessing' }
UmePNFConverter >> grammarMap [

	^ grammarMap
]

{ #category : 'accessing' }
UmePNFConverter >> grammarMap: aDictionary [

	grammarMap := aDictionary
]

{ #category : 'collecting' }
UmePNFConverter >> symbolFor: aFragment [

	(aFragment isKindOf: GncNonTerminal)
		ifTrue: [ ^ aFragment name ]
		ifFalse: [ ^ aFragment ]
]
