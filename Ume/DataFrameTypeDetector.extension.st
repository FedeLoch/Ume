Extension { #name : 'DataFrameTypeDetector' }

{ #category : '*Ume' }
DataFrameTypeDetector >> convertToBoolean: anArray [

	^ anArray collect: [ :each | each ifNotNil: [ each asLowercase = 'true' ] ]
]

{ #category : '*Ume' }
DataFrameTypeDetector >> perturbation: n [

	(n = 0) ifTrue: [ ^ self ].
	(Delay forMilliseconds: 1) wait.
	
	self perturbation: n - 1	
]
