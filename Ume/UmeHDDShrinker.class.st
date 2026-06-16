Class {
	#name : 'UmeHDDShrinker',
	#superclass : 'UmeGrammarShrinker',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeHDDShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'testing' }
UmeHDDShrinker >> checkGrammar: aInput [

	^ UmeGrammarParser accept: aInput from: grammar
]

{ #category : 'shrinking' }
UmeHDDShrinker >> deltadebugOn: nodes level: level from: currentTree [


	| currentInput granularity start subsetLength someComplementFailing |

	currentInput := nodes .
	granularity := 2.
	[currentInput size >= 2 ] whileTrue: [
		start:= 0.
		subsetLength := currentInput size // granularity.
		someComplementFailing := false.
		[ start < currentInput size ] whileTrue: [ | complement |
			self minimizationDone.
			complement := self getComplement: currentInput start: start length: subsetLength .
			(self triggerBugWith: complement atLevel: level inside: currentTree) ifTrue: [ 
				currentInput := complement.
				granularity := (granularity -1) max: 2.
				someComplementFailing := true.
				start := currentInput size.
			] ifFalse: [
				self failedMinimization.
				start := start + subsetLength
			]
		].
		
		someComplementFailing ifFalse: [ 
			(granularity = currentInput size) ifTrue:[
				^ currentInput ].
			granularity := (granularity*2) min: currentInput size.
		 ]
	].

	^ currentInput
]

{ #category : 'shrinking' }
UmeHDDShrinker >> minimizeOne: originalTree upperBound: bound [

	| level currentTree levelMax |
	currentTree := originalTree. 
	level := 1.
	levelMax := currentTree height. 
	( level <= levelMax ) whileTrue: [ 
		| nodesAtLevel minconfig |
		nodesAtLevel := currentTree "les noeud du level. ".
		(nodesAtLevel size >= 2) ifTrue: [ 
			minconfig := self deltadebugOn: nodesAtLevel level: level from: currentTree .
			currentTree := self rebuild: currentTree with: minconfig atLevel: level.
		].
		self reduce: originalTree at: level with: minconfig.
		level := level + 1.
		levelMax := currentTree height. 
	].
	
	^ currentTree 
]

{ #category : 'testing' }
UmeHDDShrinker >> rebuild: tree with: minTree atLevel: level [
]

{ #category : 'testing' }
UmeHDDShrinker >> reduce: tree at: level with: minTree [
]

{ #category : 'testing' }
UmeHDDShrinker >> triggerBug: aTree upperBound: _ [

	|input|
	
	input := (self asInput: aTree).
	(self checkGrammar: input ) ifFalse: [ ^ false ].

	^ oracle accepts: input from: _ 
]

{ #category : 'testing' }
UmeHDDShrinker >> triggerBugWith: complement atLevel: level inside: tree [
]
