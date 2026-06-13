Class {
	#name : 'UmeBugLocalization',
	#superclass : 'Object',
	#instVars : [
		'errors',
		'failures',
		'outliers'
	],
	#category : 'Ume-Localization',
	#package : 'Ume',
	#tag : 'Localization'
}

{ #category : 'accessing' }
UmeBugLocalization >> errors [

	^ errors 
]

{ #category : 'accessing' }
UmeBugLocalization >> errors: someErrors [

	errors := someErrors 
]

{ #category : 'accessing' }
UmeBugLocalization >> failures [
	
	^ failures 
]

{ #category : 'accessing' }
UmeBugLocalization >> failures: someFailures [

	failures := someFailures 
]

{ #category : 'initialization' }
UmeBugLocalization >> initialize [ 
	
	super initialize.
	errors := {}.
	failures := {}.
	outliers := {}
]

{ #category : 'accessing' }
UmeBugLocalization >> outliers [

	^ outliers 
]

{ #category : 'accessing' }
UmeBugLocalization >> outliers: someOutliers [

	outliers := someOutliers 
]

{ #category : 'as yet unclassified' }
UmeBugLocalization >> unique: reports [

	^ reports groupedBy: #bugId

]

{ #category : 'as yet unclassified' }
UmeBugLocalization >> uniqueErrors [

	^ self unique: errors
]

{ #category : 'as yet unclassified' }
UmeBugLocalization >> uniqueFailures [

	^ self unique: failures 
]

{ #category : 'as yet unclassified' }
UmeBugLocalization >> uniqueOutliers [

	^ self unique: outliers
]
