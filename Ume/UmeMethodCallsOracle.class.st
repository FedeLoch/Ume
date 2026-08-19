Class {
	#name : 'UmeMethodCallsOracle',
	#superclass : 'UmeThresholdOracle',
	#instVars : [
		'evalBlock',
		'methodsToInstrument',
		'analyzer'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'as yet unclassified' }
UmeMethodCallsOracle >> caseFor: input [

	| case |
	
	case := PBAProgram
		        from: [ evalBlock value: input ]
		        forClasses: {  }.

	case methodsToInstrument: methodsToInstrument.
	
	^ case
]

{ #category : 'accessing' }
UmeMethodCallsOracle >> evalBlock [

	^ evalBlock 
]

{ #category : 'accessing' }
UmeMethodCallsOracle >> evalBlock: aBlock [

	evalBlock := aBlock 
]

{ #category : 'as yet unclassified' }
UmeMethodCallsOracle >> evalInput: input [
	
	" return the number of methods called "
	^ (analyzer analyze: (self caseFor: input)) methodsCalled values sum
]

{ #category : 'initialization' }
UmeMethodCallsOracle >> initialize [ 

	super initialize.
	analyzer := PBAnalyzer new profilers: { PBAMethodProfiler new }
]

{ #category : 'accessing' }
UmeMethodCallsOracle >> methodsToInstrument [ 

	^ methodsToInstrument 
]

{ #category : 'accessing' }
UmeMethodCallsOracle >> methodsToInstrument: methods [

	methodsToInstrument := methods 
]
