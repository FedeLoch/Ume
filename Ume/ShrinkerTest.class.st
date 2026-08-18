Class {
	#name : 'ShrinkerTest',
	#superclass : 'Object',
	#instVars : [
		'input',
		'oracle'
	],
	#category : 'Ume-Shrinking Benchmarks',
	#package : 'Ume',
	#tag : 'Shrinking Benchmarks'
}

{ #category : 'as yet unclassified' }
ShrinkerTest class >> input: input oracle: oracle [

	^ self new input: input; oracle: oracle
]

{ #category : 'accessing' }
ShrinkerTest >> input [

	^ input
]

{ #category : 'accessing' }
ShrinkerTest >> input: anInput [

	input := anInput 
]

{ #category : 'accessing' }
ShrinkerTest >> oracle [

	^ oracle
]

{ #category : 'accessing' }
ShrinkerTest >> oracle: anOracle [

	oracle := anOracle 
]
