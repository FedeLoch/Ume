Class {
	#name : 'UmeOutlierBugReport',
	#superclass : 'UmeBugReport',
	#instVars : [
		'suspectedNodes'
	],
	#category : 'Ume-Localization',
	#package : 'Ume',
	#tag : 'Localization'
}

{ #category : 'as yet unclassified' }
UmeOutlierBugReport >> bugId [

	^ suspectedNodes asString
]

{ #category : 'accessing' }
UmeOutlierBugReport >> suspectedNodes [

	^ suspectedNodes
]

{ #category : 'accessing' }
UmeOutlierBugReport >> suspectedNodes: nodes [

	suspectedNodes := nodes
]

{ #category : 'accessing' }
UmeOutlierBugReport >> type [

	^ #outlierBug
]
