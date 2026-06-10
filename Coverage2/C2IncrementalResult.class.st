Class {
	#name : 'C2IncrementalResult',
	#superclass : 'Object',
	#instVars : [
		'coveredNodes'
	],
	#category : 'Coverage2',
	#package : 'Coverage2'
}

{ #category : 'as yet unclassified' }
C2IncrementalResult >> collectResult: collector [

	| nodes timesExecuted|

	timesExecuted := coveredNodes keys inject: Dictionary new into: [ :dic :tuple |
		dic at: (self resolveNode: tuple) put: (coveredNodes at: tuple). dic
	].
	nodes := timesExecuted keys.

	^ C2CoverageResult new
		  collector: collector;
		  timesExecuted: timesExecuted;
		  nodes: nodes;
		  methods:
			  (nodes collect: [ :node | node methodNode compiledMethod ]) asSet
]

{ #category : 'as yet unclassified' }
C2IncrementalResult >> coverNode: aNodePath inMethod: aMethodName [

	| tuple |
	
	tuple := { aMethodName. aNodePath }.

	coveredNodes at: tuple update: [ :n | n + 1 ] initial: [ 1 ].
]

{ #category : 'as yet unclassified' }
C2IncrementalResult >> initialize [

	super initialize.
	coveredNodes := IdentityDictionary new.
]

{ #category : 'as yet unclassified' }
C2IncrementalResult >> resolveNode: tuple [

	^ (Object readFrom: tuple first) ast childAtPath: tuple second 
	

]

{ #category : 'as yet unclassified' }
C2IncrementalResult >> tagExecuted: aNodePath inMethod: aMethodName [

	| tuple |

	tuple := { aMethodName. aNodePath }.
	coveredNodes at: tuple update: [ :n | n + 1 ] initial: [ 1 ].
]
