Class {
	#name : 'PerformanceOracle',
	#superclass : 'UmeInputOracle',
	#instVars : [
		'threshold'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
PerformanceOracle >> accepts: regex from: baseline [

	[ regex asRegex ] on: Error do: [ :e | ^ false ].
	
	^ (self evalInput: regex) >= (baseline * threshold)
]

{ #category : 'as yet unclassified' }
PerformanceOracle >> evalInput: regex [

	^ [ (regex asRegex matches: regex minimalStringMatching) ] microsecondsToRun
]

{ #category : 'initialization' }
PerformanceOracle >> initialize [ 

	threshold := 0.9
]

{ #category : 'initialization' }
PerformanceOracle >> valueBound: bound [

	^ bound
]
