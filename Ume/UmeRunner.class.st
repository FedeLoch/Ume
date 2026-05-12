Class {
	#name : 'UmeRunner',
	#superclass : 'Object',
	#instVars : [
		'target',
		'stopCriteria',
		'evaluator',
		'generator',
		'schema',
		'lastFeedback',
		'methodsToInstrument',
		'feedbackEvaluator',
		'shouldSaveAll'
	],
	#category : 'Ume-Runner',
	#package : 'Ume',
	#tag : 'Runner'
}

{ #category : 'tests' }
UmeRunner class >> test: schema [
	
	^ self new schema: schema; target: schema method
]

{ #category : 'tests' }
UmeRunner class >> test: schema for: time [

	^ self new
		schema: schema;
		withCriteria: (UmeTimeCriteria new timeout: time);
		target: schema method
]

{ #category : 'tests' }
UmeRunner class >> test: targetMethod from: schema [
	
	^ self new schema: schema;  target: targetMethod
]

{ #category : 'tests' }
UmeRunner class >> test: targetMethod from: schema for: time [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeTimeCriteria new timeout: time);
		target: targetMethod
]

{ #category : 'tests' }
UmeRunner class >> test: targetMethod from: schema times: times [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeCountCriteria new times: times);
		target: targetMethod
]

{ #category : 'tests' }
UmeRunner class >> test: targetMethod from: schema withCoverageTolerance: tolerance [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeStopCoverageCriteria new tolerance: tolerance);
		target: targetMethod
]

{ #category : 'tests' }
UmeRunner class >> test: schema times: times [

	^ self new
		schema: schema;
		withCriteria: (UmeCountCriteria new times: times);
		target: schema method
]

{ #category : 'tests' }
UmeRunner class >> test: schema withCoverageTolerance: tolerance [

	^ self new
		schema: schema;
		withCriteria: (UmeStopCoverageCriteria new tolerance: tolerance);
		target: schema method
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: schema [
	
	^ self new schema: schema; target: schema method; withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: schema for: time [

	^ self new
		schema: schema;
		withCriteria: (UmeTimeCriteria new timeout: time);
		target: schema method;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: targetMethod from: schema [
	
	^ self new schema: (UmeSchemaInfer enrich: schema for: targetMethod); target: targetMethod; withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: targetMethod from: schema for: time [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeTimeCriteria new timeout: time);
		target: targetMethod;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: targetMethod from: schema times: times [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeCountCriteria new times: times);
		target: targetMethod;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: targetMethod from: schema withCoverageTolerance: tolerance [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeStopCoverageCriteria new tolerance: tolerance);
		target: targetMethod;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: targetMethod from: schema withCriteria: aBlock [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeStopBlockCriteria new block: aBlock);
		target: targetMethod;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: schema times: times [

	^ self new
		schema: schema;
		withCriteria: (UmeCountCriteria new times: times);
		target: schema method;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: schema withCoverageTolerance: tolerance [

	^ self new
		schema: schema;
		withCriteria: (UmeStopCoverageCriteria new tolerance: tolerance);
		target: schema method;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithLowCost: schema withCriteria: aBlock [

	^ self new
		schema: schema;
		withCriteria: (UmeStopBlockCriteria new block: aBlock);
		target: schema method;
		withLowCost
]

{ #category : 'tests' }
UmeRunner class >> testWithPackageCoverage: schema for: time [

	^ self new
		schema: schema;
		withCriteria: (UmeTimeCriteria new timeout: time);
		targetAndPackageCoverage: schema method
]

{ #category : 'tests' }
UmeRunner class >> testWithPackageCoverage: targetMethod from: schema for: time [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeTimeCriteria new timeout: time);
		targetAndPackageCoverage: targetMethod
]

{ #category : 'tests' }
UmeRunner class >> testWithPackageCoverage: targetMethod from: schema times: times [

	^ self new
		schema: (UmeSchemaInfer enrich: schema for: targetMethod);
		withCriteria: (UmeCountCriteria new times: times);
		targetAndPackageCoverage: targetMethod
]

{ #category : 'tests' }
UmeRunner class >> testWithPackageCoverage: schema times: times [

	^ self new
		schema: schema;
		withCriteria: (UmeCountCriteria new times: times);
		targetAndPackageCoverage: schema method
]

{ #category : 'as yet unclassified' }
UmeRunner >> collectAllCases [
	shouldSaveAll := true. 
]

{ #category : 'as yet unclassified' }
UmeRunner >> continue: times from: result [

	self withCriteria: (UmeCountCriteria new times: times).
	^ self reRun: result.
]

{ #category : 'as yet unclassified' }
UmeRunner >> continueFor: time from: result [
	
	self withCriteria: (UmeTimeCriteria new timeout: time).
	^ self reRun: result.
]

{ #category : 'tests' }
UmeRunner >> evaluator [

	^ evaluator 
]

{ #category : 'tests' }
UmeRunner >> feedbackEvaluator [

	^ feedbackEvaluator
]

{ #category : 'tests' }
UmeRunner >> genReport: tests since: time withCoverage: totalCoverageResult [

	^ UmeResult resultFrom: tests since: time withCoverage: totalCoverageResult runner: self
]

{ #category : 'tests' }
UmeRunner >> genReport: tests since: time withCoverage: totalCoverageResult with: aNumberOfTest [

	^ UmeResult resultFrom: tests since: time withCoverage: totalCoverageResult runner: self with: aNumberOfTest
]

{ #category : 'tests' }
UmeRunner >> genTest: incrCoverage with: collector [

	| arguments receiver result score caseFeedback test |
	
	"Setup based on the enriched schema"
	receiver := generator genReceiverFor: target from: schema.
	arguments := generator genArgumentsFor: target from: schema.
	
	"Target call and eval result"
	result := evaluator eval: receiver method: target from: schema with: arguments andCoverage: incrCoverage collectingWith: collector.
	
	"Score calculation"
	score := self scoreFor: receiver with: arguments and: result.

	"Increment Incremental Coverage"
	incrCoverage incrementWith: result coverageResult.

	"Generate Test case"
	test := UmeTest new target: target;
		arguments: arguments;
		receiver: receiver;
		score: score;
		result: result.
	
	"Feeds the generator with the test result"
	caseFeedback := feedbackEvaluator eval: test.
	generator feed: caseFeedback.
	
	^ test feedback: caseFeedback; property: schema property; yourself
]

{ #category : 'as yet unclassified' }
UmeRunner >> guidedByAllocatedMemory [

	evaluator profilingByAllocatedMemory.
	feedbackEvaluator feedbackByAllocatedMemory
]

{ #category : 'as yet unclassified' }
UmeRunner >> guidedByBytecodes [

	evaluator profilingByBytecodes.
	feedbackEvaluator feedbackByBytecodes
]

{ #category : 'as yet unclassified' }
UmeRunner >> guidedByCoverage [

	evaluator profilingByCoverage.
	feedbackEvaluator feedbackByCoverage
]

{ #category : 'as yet unclassified' }
UmeRunner >> guidedByExecutionTime [
	
	evaluator profilingByExecutionTime.
	feedbackEvaluator feedbackByExecutionTime
]

{ #category : 'as yet unclassified' }
UmeRunner >> guidedByGCs [
	
	evaluator profilingByGCs.
	feedbackEvaluator feedbackByCGs
]

{ #category : 'as yet unclassified' }
UmeRunner >> guidedByMethodsCalls [
	
	evaluator profilingByMethodCalls.
	feedbackEvaluator feedbackByMethodsCalls
]

{ #category : 'as yet unclassified' }
UmeRunner >> guidedByScore [
	
	evaluator profilingByScore.
	feedbackEvaluator feedbackByScore
	
]

{ #category : 'tests' }
UmeRunner >> initialize [ 
	super initialize.
	evaluator := UmeEvaluator new.
	generator := UmeCaseGenerator new.
	feedbackEvaluator := UmeFeedbackEvaluator new.
	stopCriteria := UmeCountCriteria new times: 100.
	shouldSaveAll := false. 
	
	
]

{ #category : 'testing' }
UmeRunner >> isKernelMethod: method [ 
	
	^ method package name = 'Kernel'
]

{ #category : 'tests' }
UmeRunner >> progressFor: tests since: time for: iteration [
	
	^ stopCriteria progressFor: tests since: time for: iteration
]

{ #category : 'tests' }
UmeRunner >> reRun: result [

	| tests time collector incrCoverage |
	
	time := Time millisecondClockValue.
	tests := OrderedCollection new.
	collector := result totalCoverage collector.
	incrCoverage := result totalCoverage.

	collector runOn: [ [
		self shouldGenNext: tests since: time withCoverage: incrCoverage] whileTrue: [
			tests add: (self genTest: incrCoverage with: collector).
		]
	].

	^ result feed: tests time: time
]

{ #category : 'tests' }
UmeRunner >> reachableMethods [

	^ methodsToInstrument reject: [ :method |
		  method pragmas anySatisfy: [ :pragma | pragma selector = #noInstrumentation ]
	]
]

{ #category : 'tests' }
UmeRunner >> run [

	^ [ :job | self runCampaign: job ] asJob run.
]

{ #category : 'tests' }
UmeRunner >> runCampaign: executionJob [
 
	| tests test iteration time collector incrCoverage progress|
	
	time := Time millisecondClockValue.
	tests := OrderedCollection new.
	iteration := 0. 
	collector := C2CoverageCollector new methods: self reachableMethods.
	incrCoverage := IncrementalCoverageResult for: { target } from: collector.

	collector runOn: [ [
		self shouldGenNext: iteration since: time withCoverage: incrCoverage] whileTrue: [
		iteration := iteration + 1.
		test:= self genTest: incrCoverage with: collector.
		(self shouldCollect: test) ifTrue: [ tests add: test ].
		progress := self progressFor: tests since: time for: iteration.
		executionJob updateProgress: progress.
		] ].

	^ self genReport: tests since: time withCoverage: incrCoverage with: iteration.
]

{ #category : 'accessing' }
UmeRunner >> schema: propSchema [

	schema := propSchema
	
]

{ #category : 'tests' }
UmeRunner >> scoreFor: receiver with: arguments and: testResult [

	^ schema score ifNil: [ nil ] ifNotNil: [ schema score value: receiver value: arguments value: testResult ]
]

{ #category : 'tests' }
UmeRunner >> shouldCollect: test [

	^ shouldSaveAll or: [ test isOutlier ]
]

{ #category : 'tests' }
UmeRunner >> shouldGenNext: currentTests since: aTime withCoverage: aCoverage [

	^ stopCriteria shouldGenNext: currentTests since: (Time millisecondsSince: aTime) withCoverage: aCoverage
]

{ #category : 'accessing' }
UmeRunner >> target: targetMethod [

	"target selfReachableMethods <- all self called methods"

	"target package methods <- all package methods"

	"target sendReachableMethods <- all send called methods"
	target := targetMethod.

	methodsToInstrument := (self isKernelMethod: targetMethod) ifTrue:
		[ target selfReachableMethods ] ifFalse: [ target sendReachableMethods ]
	
]

{ #category : 'accessing' }
UmeRunner >> targetAndPackageCoverage: targetMethod [

	"target selfReachableMethods <- all self called methods"

	"target package methods <- all package methods"

	"target sendReachableMethods <- all send called methods"
	
	target := targetMethod.
	methodsToInstrument := target package methods.
	
]

{ #category : 'tests' }
UmeRunner >> withCriteria: aCriteria [

	stopCriteria := aCriteria 
]

{ #category : 'tests' }
UmeRunner >> withLowCost [

	methodsToInstrument := { target } "target selfReachableMethods"
]
