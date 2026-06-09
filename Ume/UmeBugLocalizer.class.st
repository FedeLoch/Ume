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
	allMethods do: [ :method |
		| failed passed divisor score |
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
UmeBugLocalizer >> computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: valueBlock [

	| outlierValues normalValues allKeys deltas |
	outlierValues := Dictionary new.
	normalValues := Dictionary new.
	allKeys := Set new.

	outlierTests do: [ :test | | values |
		values := valueBlock value: test.
		values keysAndValuesDo: [ :key :val |
			allKeys add: key.
			outlierValues at: key put: (outlierValues at: key ifAbsent: [ 0 ]) + val ] ].

	outlierTests ifNotEmpty: [
		outlierValues keysAndValuesDo: [ :key :sum |
			outlierValues at: key put: sum / outlierTests size ] ].

	normalTests do: [ :test | | values |
		values := valueBlock value: test.
		values keysAndValuesDo: [ :key :val |
			allKeys add: key.
			normalValues at: key put: (normalValues at: key ifAbsent: [ 0 ]) + val ] ].

	normalTests ifNotEmpty: [
		normalValues keysAndValuesDo: [ :key :sum |
			normalValues at: key put: sum / normalTests size ] ].

	deltas := Dictionary new.
	allKeys do: [ :key |
		| outlierAvg normalAvg delta |
		outlierAvg := outlierValues at: key ifAbsent: [ 0.0 ].
		normalAvg := normalValues at: key ifAbsent: [ 0.0 ].
		delta := outlierAvg - normalAvg.
		delta > 0 ifTrue: [ deltas at: key put: delta ] ].

	^ deltas
]

{ #category : 'localization' }
UmeBugLocalizer >> localize: umeResult [

	^ {
		'Errors' -> (self localizeErrors: umeResult).
		'Failures' -> (self localizeFailures: umeResult).
		'OutlierCauses' -> (self localizePerformanceOutliers: umeResult)
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

	| outlierTests normalTests deltas bugs |
	
	bugs := OrderedCollection new.
	1 halt.
	outlierTests := umeResult outliersByCoverage.
	outlierTests ifEmpty: [ ^ bugs ].

	normalTests := umeResult tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ bugs ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ bugs ].

	outlierTests do: [ :test |
		| bug orderedSuspects |
		bug := UmeBugReport for: test type: #performanceOutlier.
		bug metric: #coverage.
		bug suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		bug suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			bug executedMethods: cov methods ].

		bugs add: bug ].
	
	^ bugs
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliers: umeResult [

	^ self localizeOutliers: umeResult
"	self localizePerformanceOutliersByExecutionTime: umeResult.
	self localizePerformanceOutliersByMemory: umeResult.
	self localizePerformanceOutliersByCoverage: umeResult.
	self localizePerformanceOutliersByScore: umeResult"
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByCoverage: umeResult [

	| outlierTests normalTests deltas bugs |
	
	bugs := OrderedCollection new.
	outlierTests := umeResult outliersByCoverage.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := umeResult tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ self ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ self ].

	outlierTests do: [ :test |
		| bug orderedSuspects |
		bug := UmeBugReport for: test type: #performanceOutlier.
		bug metric: #coverage.
		bug suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		bug suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			bug executedMethods: cov methods ].

		bugs add: bug ].
	
	^ bugs
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByExecutionTime: umeResult [

	| outlierTests normalTests deltas bugs |
	
	bugs := OrderedCollection new.
	outlierTests := umeResult outliersByExecutionTime.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := umeResult tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ self ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ self ].

	outlierTests do: [ :test |
		| bug orderedSuspects |
		bug := UmeBugReport for: test type: #performanceOutlier.
		bug metric: #executionTime.
		bug suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		bug suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			bug executedMethods: cov methods ].

		bugs add: bug ].
	
	^ bugs
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByMemory: umeResult [

	| outlierTests normalTests deltas bugs |
	
	bugs := OrderedCollection new.
	outlierTests := umeResult outliersByAllocatedMemory.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := umeResult tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ self ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ self ].

	outlierTests do: [ :test |
		| report orderedSuspects |
		report := UmeBugReport for: test type: #performanceOutlier.
		report metric: #allocatedMemory.
		report suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		report suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			report executedMethods: cov methods ].

		bugs add: report ].
	
	^ bugs
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByScore: umeResult [

	| outlierTests normalTests deltas bugs |
	
	bugs := OrderedCollection new.
	outlierTests := umeResult outliersByScore.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := umeResult tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ self ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ self ].

	outlierTests do: [ :test |
		| bug orderedSuspects |
		bug := UmeBugReport for: test type: #performanceOutlier.
		bug metric: #score.
		bug suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		bug suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			bug executedMethods: cov methods ].

		bugs add: bug ].
	
	^ bugs
]
