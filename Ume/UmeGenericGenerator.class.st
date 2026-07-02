Class {
	#name : 'UmeGenericGenerator',
	#superclass : 'UmeGenerator',
	#instVars : [
		'do',
		'prevFeedback',
		'mutationMetadataBlock'
	],
	#category : 'Ume-Generators',
	#package : 'Ume',
	#tag : 'Generators'
}

{ #category : 'ston-core' }
UmeGenericGenerator class >> stonAllInstVarNames [

	^ super stonAllInstVarNames copyWithoutAll: #( do )
]

{ #category : 'accessing' }
UmeGenericGenerator >> do [

	^ do
]

{ #category : 'accessing' }
UmeGenericGenerator >> do: aBlock [

	do := aBlock
]

{ #category : 'accessing' }
UmeGenericGenerator >> feed: feedback [

	prevFeedback := feedback 
]

{ #category : 'accessing' }
UmeGenericGenerator >> gen: constraint [

	^ do value: (constraint ifNotNil: [ constraint props ] ifNil: nil) value: prevFeedback
]

{ #category : 'accessing' }
UmeGenericGenerator >> mutationMetadata [

	^ mutationMetadataBlock ifNotNil: [ mutationMetadataBlock value ] ifNil: [ nil ]
]

{ #category : 'accessing' }
UmeGenericGenerator >> mutationMetadataBlock: aBlock [

	mutationMetadataBlock := aBlock 
]
