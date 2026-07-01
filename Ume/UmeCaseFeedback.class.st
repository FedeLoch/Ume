Class {
	#name : 'UmeCaseFeedback',
	#superclass : 'UmeFeedback',
	#instVars : [
		'argumentsMutationMetadata',
		'receiverMutationMetadata'
	],
	#category : 'Ume-Feedback',
	#package : 'Ume',
	#tag : 'Feedback'
}

{ #category : 'as yet unclassified' }
UmeCaseFeedback >> absoluteImprovement [
	
	^ self values values sum
]

{ #category : 'as yet unclassified' }
UmeCaseFeedback >> argumentFeedbackCase: index [
	
	^ UmeFeedback from: (case arguments at: index) improvement: improvement values: values
]

{ #category : 'accessing' }
UmeCaseFeedback >> argumentsMutationMetadata [

	^ argumentsMutationMetadata
]

{ #category : 'accessing' }
UmeCaseFeedback >> argumentsMutationMetadata: data [

	argumentsMutationMetadata := data
]

{ #category : 'accessing' }
UmeCaseFeedback >> initialize [ 

	super initialize.
	argumentsMutationMetadata := OrderedCollection new.
]

{ #category : 'accessing' }
UmeCaseFeedback >> mutationMetadata [

	^ {
		'argumentsMutationMetadata' -> argumentsMutationMetadata.
		'receiverMutationMetadata' -> receiverMutationMetadata
	} asDictionary
]

{ #category : 'as yet unclassified' }
UmeCaseFeedback >> receiverFeedback [

	^ UmeFeedback from: case receiver improvement: improvement values: values
]

{ #category : 'accessing' }
UmeCaseFeedback >> receiverMutationMetadata [
	
	^ receiverMutationMetadata
]

{ #category : 'accessing' }
UmeCaseFeedback >> receiverMutationMetadata: data [

	receiverMutationMetadata := data
]
