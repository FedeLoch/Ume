Class {
	#name : 'UmeBugLocalizer',
	#superclass : 'Object',
	#category : 'Ume-Localization',
	#package : 'Ume',
	#tag : 'Localization'
}

{ #category : 'instance creation' }
UmeBugLocalizer class >> localize: aUmeResult [

	^ self new localize: aUmeResult
]

{ #category : 'localization' }
UmeBugLocalizer >> computeOchiaiForPassing: passingTests failing: failingTests [

	| totalFailed suspiciousness allMethods methodFailedCount methodPassedCount |
	totalFailed := failingTests size.
	totalFailed = 0 ifTrue: [ ^ Dictionary new ].

	allMethods := Set new.
	methodFailedCount := Dictionary new.
	methodPassedCount := Dictionary new.

	passingTests do: [ :test |
		(test result coverageResult ifNil: [ #() ] ifNotNil: [ test result coverageResult methods ]) do: [ :method |
			allMethods add: method.
			methodPassedCount at: method put: (methodPassedCount at: method ifAbsent: [ 0 ]) + 1 ] ].

	failingTests do: [ :test |
		(test result coverageResult ifNil: [ #() ] ifNotNil: [ test result coverageResult methods ]) do: [ :method |
			allMethods add: method.
			methodFailedCount at: method put: (methodFailedCount at: method ifAbsent: [ 0 ]) + 1 ] ].

	suspiciousness := Dictionary new.
	allMethods do: [ :method | | failed passed divisor score |
		failed := methodFailedCount at: method ifAbsent: [ 0 ].
		passed := methodPassedCount at: method ifAbsent: [ 0 ].
		divisor := totalFailed * (failed + passed) asFloat.
		score := divisor > 0
			ifTrue: [ failed / divisor sqrt ]
			ifFalse: [ 0.0 ].
		score > 0 ifTrue: [ suspiciousness at: method put: score ] ].

	^ suspiciousness
]

{ #category : 'localization' }
UmeBugLocalizer >> coveredMethodDeltaBetween: baseline and: test [

	| baselineMethods testMethods |
	
	baselineMethods := baseline result coverageResult methods.
	testMethods := test result coverageResult methods.

	^ testMethods difference: baselineMethods
]

{ #category : 'localization' }
UmeBugLocalizer >> coveredNodesDeltaBetween: baseline and: test [
	
	| baselineNodes testNodes |

	baselineNodes := baseline result coverageResult timesExecuted.
	testNodes := test result coverageResult timesExecuted.

	^ testNodes keys inject: Dictionary new into: [ :dic :key | | currentValue baselineValue |
		currentValue := testNodes at: key.
		baselineValue := baselineNodes at: key ifAbsent: [ 0 ].
		(currentValue > baselineValue) ifTrue: [
			dic at: key put: (currentValue - baselineValue)
		].
		dic	
	]
]

{ #category : 'localization' }
UmeBugLocalizer >> localize: umeResult [

	^ {
		'Errors' -> (self localizeErrors: umeResult).
		'Failures' -> (self localizeFailures: umeResult).
		'Outliers' -> (self localizeOutliers: umeResult)
	} asDictionary
]

{ #category : 'localization' }
UmeBugLocalizer >> localizeErrors: umeResult [

	^ umeResult tests inject: OrderedCollection new into: [ :bugs :test |
		test result isError ifTrue: [ bugs add: (UmeBugReport errorReport: test) ].
		bugs
	]
]

{ #category : 'localization' }
UmeBugLocalizer >> localizeFailures: umeResult [

	| failingTests passingTests suspiciousness |

	failingTests := umeResult tests select: [ :t | t result isFail ].
	failingTests ifEmpty: [ ^ failingTests ].

	passingTests := umeResult tests select: [ :t | t result isSuccess ].
	passingTests ifEmpty: [ ^ passingTests ].

	suspiciousness := self computeOchiaiForPassing: passingTests failing: failingTests.

	^ failingTests collect: [ :test | UmeBugReport failReport: test from: suspiciousness ]
]

{ #category : 'localization' }
UmeBugLocalizer >> localizeOutliers: umeResult [

	| outliers baseline bugBaseline outlierbugs |

	umeResult topCases ifEmpty: [ ^ OrderedCollection new ].
	outliers := umeResult topCases allButFirst select: [ :test | test result isSuccess ].
	baseline := umeResult topCases first.
	bugBaseline := UmeBugReport outlierBaseline: baseline.
	
	outlierbugs := outliers collect: [ :test | | bug delta deltaMethods deltaNodes |
		delta := self profilingDeltaBetween: baseline and: test.
		deltaMethods := self coveredMethodDeltaBetween: baseline and: test.
		deltaNodes := self coveredNodesDeltaBetween: baseline and: test.
		bug := UmeBugReport outlierReport: test delta: delta suspectedMethods: deltaMethods suspectedNodes: deltaNodes.
		baseline := test.
		bug
	].
	
	^ { bugBaseline }, outlierbugs

]

{ #category : 'localization' }
UmeBugLocalizer >> profilingDeltaBetween: baseline and: test [

	| baselineValues testValues |
	
	baselineValues := baseline feedback values.
	testValues := test feedback values.

	^ testValues keys inject: Dictionary new into: [ :diff :key | | currentValue baselineValue |
		currentValue := testValues at: key.
		baselineValue := baselineValues at: key ifAbsent: [ 0 ].
		(currentValue > baselineValue) ifTrue: [
			diff at: key put: (currentValue - baselineValue)
		].
		diff
	]
]
