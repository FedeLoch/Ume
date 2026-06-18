Extension { #name : 'GncInnerNode' }

{ #category : '*Ume' }
GncInnerNode >> allChildAtLevel: level currentLevel: currentLevel [

	| result |
	
	result := OrderedCollection new. 
	( level = currentLevel ) ifTrue: [ ^ OrderedCollection with: self ].
	( self children ) ifEmpty: [ ^ OrderedCollection new ].
	( self children ) do: [ :child |
		( child isLeaf) ifFalse: [ result addAll: (child allChildAtLevel: level currentLevel: currentLevel +1) ] ].
	^ result 

]

{ #category : '*Ume' }
GncInnerNode >> allNodesAtLevel: level [

	^ self allChildAtLevel: level currentLevel: 0
]

{ #category : '*Ume' }
GncInnerNode >> asClassInstanceObject [

	| objectClass |

	objectClass := self objectClass.

	^ (1 to: children size by: 2) inject: objectClass basicNew into: [ :inst :index | | value |
		value := (children at: index + 1) asPharoObject.
		inst instVarNamed: (children at: index) varName put: value.
		inst
	]
]

{ #category : '*Ume' }
GncInnerNode >> asPharoObject [

	^ self isClassObject
		  ifTrue: [ self asClassInstanceObject ]
		  ifFalse: [ self asPrimitiveObject ]
]

{ #category : '*Ume' }
GncInnerNode >> backPropagateToChildren: reward [

	self children do: [ :child | child backPropagateRecursive: reward ]
]

{ #category : '*Ume' }
GncInnerNode >> backPropagateToChildren: reward level: level [

	self children do: [ :child | child backPropagateRecursive: reward level: level ]
]

{ #category : '*Ume' }
GncInnerNode >> indexOf: aNode [

	^ children indexOf: aNode
]

{ #category : '*Ume' }
GncInnerNode >> isClassObject [

	^ children first isTypeVariable
]

{ #category : '*Ume' }
GncInnerNode >> levelOf: subTree [

	^ ( self treeHeight - subTree treeHeight )
]

{ #category : '*Ume' }
GncInnerNode >> objectClass [

	^ tag asClassInEnvironment: self class environment
]

{ #category : '*Ume' }
GncInnerNode >> removeChildAt: index [ 

	children removeAt: index.
]

{ #category : '*Ume' }
GncInnerNode >> replaceChild: child by: newChild [

	| index |

	index := children indexOf: child.
	self replaceChildAt: index with: newChild
]

{ #category : '*Ume' }
GncInnerNode >> replaceChildAt: index with: newNode [

	children at: index put: newNode.
	newNode parent: self.
]
