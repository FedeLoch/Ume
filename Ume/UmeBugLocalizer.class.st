Class {
	#name : 'UmeBugLocalizer',
	#superclass : 'Object',
	#instVars : [
		'result',
		'reports'
	],
	#category : 'Ume-Localization',
	#package : 'Ume',
	#tag : 'Localization'
}

{ #category : 'instance creation' }
UmeBugLocalizer class >> on: aUmeResult [

	^ self new result: aUmeResult
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
UmeBugLocalizer >> localize: aUmeResult [

	result := aUmeResult.
	reports := OrderedCollection new.

	self localizeErrors.
	self localizeFailures.
	self localizePerformanceOutliers.

	^ reports
]

{ #category : 'localization' }
UmeBugLocalizer >> localizeErrors [

	result tests do: [ :test |
		(test result isKindOf: UmeEvalError) ifTrue: [ | report topFrames |
			report := UmeBugReport for: test type: #error.
			report errorMessage: test result message.

			test result stack ifNotNil: [ :frames |
				report stackTrace: frames.
				topFrames := frames first: ((frames size) min: 3).
				report suspectedMethods: (topFrames collect: [ :frame | frame asString ]) asOrderedCollection ].

			test result coverageResult ifNotNil: [ :cov |
				report executedMethods: cov methods.
				report uncoveredMethods: cov uncoveredMethods ].

			reports add: report ] ]
]

{ #category : 'localization' }
UmeBugLocalizer >> localizeFailures [

	| failingTests passingTests suspiciousness |
	failingTests := result tests select: [ :t | t result isKindOf: UmeEvalFail ].
	failingTests ifEmpty: [ ^ self ].

	passingTests := result tests select: [ :t | t result isKindOf: UmeEvalSuccess ].
	passingTests ifEmpty: [ ^ self ].

	suspiciousness := self computeOchiaiForPassing: passingTests failing: failingTests.
	suspiciousness ifEmpty: [ ^ self ].

	failingTests do: [ :test |
		| report orderedSuspects |
		report := UmeBugReport for: test type: #propertyFail.
		report suspiciousnessScores: suspiciousness.

		orderedSuspects := (suspiciousness keys asSortedCollection: [ :a :b |
			(suspiciousness at: a) > (suspiciousness at: b) ]) asOrderedCollection.
		report suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			report executedMethods: cov methods.
			report uncoveredMethods: cov uncoveredMethods ].

		reports add: report ]
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliers [

	self localizePerformanceOutliersByExecutionTime.
	self localizePerformanceOutliersByMemory.
	self localizePerformanceOutliersByCoverage.
	self localizePerformanceOutliersByScore
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByExecutionTime [

	| outlierTests normalTests deltas |
	outlierTests := result outliersByExecutionTime.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := result tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ self ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ self ].

	outlierTests do: [ :test |
		| report orderedSuspects |
		report := UmeBugReport for: test type: #performanceOutlier.
		report metric: #executionTime.
		report suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		report suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			report executedMethods: cov methods ].

		reports add: report ]
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByMemory [

	| outlierTests normalTests deltas |
	outlierTests := result outliersByAllocatedMemory.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := result tests select: [ :t |
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

		reports add: report ]
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByCoverage [

	| outlierTests normalTests deltas |
	outlierTests := result outliersByCoverage.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := result tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ self ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ self ].

	outlierTests do: [ :test |
		| report orderedSuspects |
		report := UmeBugReport for: test type: #performanceOutlier.
		report metric: #coverage.
		report suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		report suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			report executedMethods: cov methods ].

		reports add: report ]
]

{ #category : 'localization' }
UmeBugLocalizer >> localizePerformanceOutliersByScore [

	| outlierTests normalTests deltas |
	outlierTests := result outliersByScore.
	outlierTests ifEmpty: [ ^ self ].

	normalTests := result tests select: [ :t |
		(outlierTests includes: t) not and: [ t result isKindOf: UmeEvalSuccess ] ].
	normalTests ifEmpty: [ ^ self ].

	deltas := self computeProfilingDeltaForOutliers: outlierTests normal: normalTests valueBlock: [ :test |
		test result profilingResult ifNil: [ Dictionary new ] ifNotNil: [ :pr |
			(pr respondsTo: #methodsCalled) ifTrue: [ pr methodsCalled ] ifFalse: [ Dictionary new ] ] ].

	deltas ifEmpty: [ ^ self ].

	outlierTests do: [ :test |
		| report orderedSuspects |
		report := UmeBugReport for: test type: #performanceOutlier.
		report metric: #score.
		report suspiciousnessScores: deltas.

		orderedSuspects := (deltas keys asSortedCollection: [ :a :b |
			(deltas at: a) > (deltas at: b) ]) asOrderedCollection.
		report suspectedMethods: orderedSuspects.

		test result coverageResult ifNotNil: [ :cov |
			report executedMethods: cov methods ].

		reports add: report ]
]

{ #category : 'accessing' }
UmeBugLocalizer >> reports [

	^ reports
]

{ #category : 'accessing' }
UmeBugLocalizer >> result [

	^ result
]

{ #category : 'accessing' }
UmeBugLocalizer >> result: aUmeResult [

	result := aUmeResult
]
