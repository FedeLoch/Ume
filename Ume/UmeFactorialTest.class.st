Class {
	#name : 'UmeFactorialTest',
	#superclass : 'UmeFrameworkTest',
	#instVars : [
		'schema',
		'receiverConstraint',
		'assert'
	],
	#category : 'Ume-Framework Tests',
	#package : 'Ume',
	#tag : 'Framework Tests'
}

{ #category : 'running' }
UmeFactorialTest >> setUp [
	super setUp.
	
	receiverConstraint := UmeObjectConstraint new generator: (UmeGenerator oneOf: (10 to: 100)).
	assert := [ :n :args :result | n * (n - 1) factorial = result ].
	schema := UmeSchema new receiverConstraint: receiverConstraint; property: assert; method: Integer >> #factorial.
]

{ #category : 'tests' }
UmeFactorialTest >> testGivingASmallIntegerSchemaThenValidateFactorialResult [

	| result |

	result := (UmeRunner test: schema) run.

	self assertSuccess: result.
	self assert: (result tests size) equals: 100.
]

{ #category : 'tests' }
UmeFactorialTest >> testGivingASmallIntegerSchemaThenValidateFactorialResultFromSpecificCountOfIterations [

	| result |

	result := (UmeRunner test: schema times: 2542) run.

	self assertSuccess: result.
	self assert: (result tests size) equals: 2542.
]

{ #category : 'tests' }
UmeFactorialTest >> testGivingASmallIntegerSchemaThenValidateFactorialResultFromTimeIsnteadOfIterations [

	| result |

	result := (UmeRunner test: schema for: 2 seconds) run.

	self assertSuccess: result.
	self assert: (result totalTime >= 2 seconds) equals: true.
]

{ #category : 'tests' }
UmeFactorialTest >> testGivingASmallIntegerSchemaThenValidateFactorialResultWithoutSchema [
	
	| result |
	"TODO: Not executable until we support schema inference"
	result := (UmeRunner test: Integer >> #factorial) run.
	
	self assertSuccess: result.
	self assert: (result tests size) equals: 1000.
]
