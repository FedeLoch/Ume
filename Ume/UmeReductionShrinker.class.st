Class {
	#name : 'UmeReductionShrinker',
	#superclass : 'UmeShrinker',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeReductionShrinker >> minimize: tree upperBound: bound [

	"1- on garde en memoire la plus petite input"
	| reduceInput |
	"todo regarder si il a bien des enfants"
	
	"while true"
		"loop on all the children"
			"1- on regarde si il est pllus petit que le reduceInput actuel"
			"2- si il fail il devient le nouveau reduce input"
	
]

{ #category : 'shrinking' }
UmeReductionShrinker >> tree: input [

	^ self parse: input
]
