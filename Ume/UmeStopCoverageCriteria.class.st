Class {
	#name : 'UmeStopCoverageCriteria',
	#superclass : 'UmeStopCriteria',
	#instVars : [
		'tolerance',
		'previousCoverage',
		'timesWithouImprovement'
	],
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'asserting' }
UmeStopCoverageCriteria >> improvesCoverage: aCoverage [
	"previousCoverage is the percentage reached in the previous iteration.
	 It must be a number: the coverage result is mutated in place, so keeping the object would always compare it with itself"

	| currentPercent |
	currentPercent := aCoverage asPercent.
	previousCoverage ifNil: [ ^ true ].

	currentPercent > previousCoverage
		ifTrue: [ timesWithouImprovement := tolerance ]
		ifFalse: [ timesWithouImprovement := timesWithouImprovement - 1 ].

	^ timesWithouImprovement > 0
]

{ #category : 'asserting' }
UmeStopCoverageCriteria >> initialize [ 
	
	super initialize.
	tolerance := 100.
	timesWithouImprovement := tolerance .
]

{ #category : 'asserting' }
UmeStopCoverageCriteria >> isNotOneHundredPercent: aCoverage [

	^ aCoverage asPercent ~= 100
]

{ #category : 'asserting' }
UmeStopCoverageCriteria >> progressFor: tests since: time for: iteration [
	
	previousCoverage ifNil: [ ^0 ]. 

	^ previousCoverage
]

{ #category : 'asserting' }
UmeStopCoverageCriteria >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	| res |
	"Stop when the coverage is not improved since X iterations or the last coverage got 100%"
	res := (self isNotOneHundredPercent: aCoverage) and: [ self improvesCoverage: aCoverage ].
	previousCoverage := aCoverage asPercent.
	^ res
]

{ #category : 'accessing' }
UmeStopCoverageCriteria >> tolerance: aTolerance [

	tolerance := aTolerance.
	timesWithouImprovement := aTolerance.
]
