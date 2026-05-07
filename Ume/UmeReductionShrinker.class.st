Class {
	#name : 'UmeReductionShrinker',
	#superclass : 'UmeShrinker',
	#instVars : [
		'method'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeReductionShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'as yet unclassified' }
UmeReductionShrinker >> computeTree: subtree with: bound [

	"on regarde si le subtree produit bien l'erreur "
]

{ #category : 'shrinking' }
UmeReductionShrinker >> method [ 
	
	^method. 
]

{ #category : 'shrinking' }
UmeReductionShrinker >> method: aMethod [

	method := aMethod. 
]

{ #category : 'shrinking' }
UmeReductionShrinker >> minimize: tree upperBound: bound [

	"1- on garde en memoire la plus petite input"
	| allNodes reductionSet|
	"todo regarder si il a bien des enfants"
	
	reductionSet := tree. 
	allNodes := tree allNodes asSet. 
	"True whileTrue: [ "
		allNodes do: [ :subtree |
			| result success | 
			( subtree size < reductionSet size ) ifTrue: [ 
				result := self computeTree: subtree with: bound.
				success := result first.
				success ifFalse: [ reductionSet:= result second ].
				]	
			]. "todo: ne pas avoir les memes resultats 2 fois"
		"]"
	^reductionSet. 
	
]

{ #category : 'shrinking' }
UmeReductionShrinker >> tree: input [

	^ self parse: input
]
