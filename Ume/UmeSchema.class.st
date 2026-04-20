Class {
	#name : 'UmeSchema',
	#superclass : 'Object',
	#instVars : [
		'property',
		'argumentConstraints',
		'receiverConstraint',
		'score'
	],
	#category : 'Ume-Property Schema',
	#package : 'Ume',
	#tag : 'Property Schema'
}

{ #category : 'ston-core' }
UmeSchema class >> stonAllInstVarNames [

	^ super stonAllInstVarNames copyWithoutAll: #( #property #score )
]

{ #category : 'accessing' }
UmeSchema >> argumentConstraints [

	^ argumentConstraints 
]

{ #category : 'accessing' }
UmeSchema >> argumentConstraints: anArgumentConstraints [

	argumentConstraints := anArgumentConstraints.
]

{ #category : 'initialization' }
UmeSchema >> initialize [ 

	super initialize.
	argumentConstraints := #().
	receiverConstraint := nil.
]

{ #category : 'accessing' }
UmeSchema >> merge: anotherSchema [

	self mergeReceiverConstraint: anotherSchema receiverConstraint.
	self mergeArgumentConstraint: anotherSchema argumentConstraints.
	self mergeProperty: anotherSchema property. 
	"TODO:
		Think how to index the schema, for the moment the schema respect the next structure:
		{
			objectConstraint: Constraint,
			inputConstraints: [ Constraint ],
			assert: Block
		},
		But maybe the best structure could be:
		{
			[ Class/Type ]: {
				objectConstraint: Constraint,
				methods: {
					[ method ]: { inputsConstraint: [ Constraint ], assert: aBlock }
				}
			}
		}
		
		A Constraint looks as follow:
		{
			objectClass: Class, gen: aBlock, props: { variable: Class }
		}
	"
	^ self
]

{ #category : 'accessing' }
UmeSchema >> mergeArgumentConstraint: someArgumentConstraints [

	argumentConstraints ifNil: [ ^ argumentConstraints := someArgumentConstraints ].

]

{ #category : 'accessing' }
UmeSchema >> mergeProperty: aProperty [

	property ifNil: [ ^ property := aProperty ].
]

{ #category : 'accessing' }
UmeSchema >> mergeReceiverConstraint: aReceiverConstraint [

	receiverConstraint ifNil: [ receiverConstraint := aReceiverConstraint ].
]

{ #category : 'accessing' }
UmeSchema >> property [

	^ property 
]

{ #category : 'accessing' }
UmeSchema >> property: anAssertBlock [

	property := anAssertBlock
]

{ #category : 'accessing' }
UmeSchema >> receiverConstraint [

	^ receiverConstraint
]

{ #category : 'accessing' }
UmeSchema >> receiverConstraint: aReceiverConstraint [

	receiverConstraint := aReceiverConstraint.
]

{ #category : 'accessing' }
UmeSchema >> score [

	^ score
]

{ #category : 'accessing' }
UmeSchema >> score: aBlock [

	score := aBlock 
]
