Class {
	#name : 'UmeShrinkingBenchmark',
	#superclass : 'Object',
	#instVars : [
		'shrinkers',
		'tests',
		'grammar'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
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

	| results |
	
	results := tests collect: [ :test | | shrinker |
		shrinker := shrinkerClass new grammar: grammar; oracle: test oracle.
		shrinker profiledShrink: test input.
	].

	^ UmeShrinkingBenchmarkReport keys inject: Dictionary new into: [ :result :key |
		result at: key put: (results collect: [ :report | report at: key ]) average.
		result
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
