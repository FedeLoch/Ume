Class {
	#name : 'UmeShrinkingBenchmark',
	#superclass : 'Object',
	#instVars : [
		'shrinkers',
		'tests',
		'grammar'
	],
	#category : 'Ume-Shrinking Benchmarks',
	#package : 'Ume',
	#tag : 'Shrinking Benchmarks'
}

{ #category : 'instance creation' }
UmeShrinkingBenchmark class >> for: shrinkerClasses [

	^ self new shrinkers: shrinkerClasses
]

{ #category : 'initialization' }
UmeShrinkingBenchmark >> bench [

	^ shrinkers inject: UmeShrinkingBenchmarkReport new into: [ :report :shrinkerClass |
		report add: (self benchShrinker: shrinkerClass) for: shrinkerClass
	]
]

{ #category : 'initialization' }
UmeShrinkingBenchmark >> benchShrinker: shrinkerClass [
	
	^ tests collect: [ :test | | shrinker |
		shrinker := shrinkerClass new grammar: grammar; oracle: test oracle.
		shrinker profiledShrink: test input.
	]
]

{ #category : 'accessing' }
UmeShrinkingBenchmark >> grammar [

	^ grammar 
]

{ #category : 'accessing' }
UmeShrinkingBenchmark >> grammar: inputGrammar [
	
	grammar := inputGrammar
]

{ #category : 'initialization' }
UmeShrinkingBenchmark >> initialize [ 

	super initialize.
	tests := {}.
]

{ #category : 'accessing' }
UmeShrinkingBenchmark >> shrinkers [

	^ shrinkers 
]

{ #category : 'accessing' }
UmeShrinkingBenchmark >> shrinkers: shrinkerClasses [

	shrinkers := shrinkerClasses
]
