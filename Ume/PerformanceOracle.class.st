Class {
	#name : 'PerformanceOracle',
	#superclass : 'UmeInputOracle',
	#instVars : [
		'preservation',
		'timerList'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
PerformanceOracle >> accepts: input from: regex [
	
	^ (regex asRegex) matches: input
]

{ #category : 'initialization' }
PerformanceOracle >> initialize [ 

	preservation := 0.9. 
	timerList := OrderedCollection new. 
]

{ #category : 'initialization' }
PerformanceOracle >> problemPresence: input [

	^ [  ]
]
