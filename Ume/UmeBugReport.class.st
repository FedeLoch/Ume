Class {
	#name : 'UmeBugReport',
	#superclass : 'Object',
	#instVars : [
		'test',
		'suspectedMethods',
		'delta',
		'executedMethods'
	],
	#category : 'Ume-Localization',
	#package : 'Ume',
	#tag : 'Localization'
}

{ #category : 'instance creation' }
UmeBugReport class >> errorReport: test [

	| bug topFrames |

	bug := UmeErrorBugReport new test: test.
	bug errorMessage: test result message.

	test result stack ifNotNil: [ :frames |
		bug stackTrace: frames.
		topFrames := frames first: (frames size min: 3).
		bug suspectedMethods: (topFrames collect: [ :frame | frame method ])
	].

	test result coverageResult ifNotNil: [ :cov | bug executedMethods: cov methods ].
	
	^ bug
]

{ #category : 'instance creation' }
UmeBugReport class >> failReport: test from: suspiciousness [

	| bug orderedSuspects |

	bug := UmeFailBugReport new test: test.
	bug delta: suspiciousness.

	orderedSuspects := (suspiciousness keys asSortedCollection: [ :a :b |
		                    (suspiciousness at: a) > (suspiciousness at: b) ])
		                   asOrderedCollection.

	bug suspectedMethods: orderedSuspects.

	test result coverageResult ifNotNil: [ :cov | bug executedMethods: cov methods ].

	^ bug
]

{ #category : 'instance creation' }
UmeBugReport class >> outlierBaseline: baseline [

	| bug |
	
	bug := UmeOutlierBaseline new test: baseline.

	bug delta: baseline feedback values.

	baseline result coverageResult ifNotNil: [ :cov |
		bug executedMethods: cov methods.
		bug suspectedMethods: cov methods.
		bug suspectedNodes: cov nodes.
	].

	^ bug
]

{ #category : 'instance creation' }
UmeBugReport class >> outlierReport: test delta: delta suspectedMethods: deltaMethods suspectedNodes: deltaNodes [

	| bug |
	
	bug := UmeOutlierBugReport new test: test.
	bug delta: delta.
	bug suspectedMethods: deltaMethods.
	bug suspectedNodes: deltaNodes.

	test result coverageResult ifNotNil: [ :cov | bug executedMethods: cov methods ].

	^ bug
]

{ #category : 'accessing' }
UmeBugReport >> delta [

	^ delta
]

{ #category : 'accessing' }
UmeBugReport >> delta: aDelta [

	delta := aDelta
]

{ #category : 'printing' }
UmeBugReport >> errorMessage [

	^ nil
]

{ #category : 'accessing' }
UmeBugReport >> executedMethods [

	^ executedMethods
]

{ #category : 'accessing' }
UmeBugReport >> executedMethods: aSet [

	executedMethods := aSet
]

{ #category : 'accessing' }
UmeBugReport >> suspectedMethods [

	^ suspectedMethods
]

{ #category : 'accessing' }
UmeBugReport >> suspectedMethods: anOrderedCollection [

	suspectedMethods := anOrderedCollection
]

{ #category : 'accessing' }
UmeBugReport >> test [

	^ test
]

{ #category : 'accessing' }
UmeBugReport >> test: aUmeTest [

	test := aUmeTest
]
