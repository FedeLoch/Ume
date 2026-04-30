Class {
	#name : 'UmeAPITest',
	#superclass : 'TestCase',
	#category : 'Ume-API Tests',
	#package : 'Ume',
	#tag : 'API Tests'
}

{ #category : 'tests' }
UmeAPITest >> assertSuccess: result [

	self assert: ( self successful: result ).
]

{ #category : 'running' }
UmeAPITest >> setUp [
	
	super setUp.
	self timeLimit: 1 minute. 
]

{ #category : 'as yet unclassified' }
UmeAPITest >> successful: aResult [

	^ self subclassResponsibility 
]
