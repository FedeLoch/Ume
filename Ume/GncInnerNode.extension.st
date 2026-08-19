Extension { #name : 'GncInnerNode' }

{ #category : '*Ume' }
GncInnerNode >> allChildAtLevel: level currentLevel: currentLevel [

	^ ( level = currentLevel ) ifTrue: [ OrderedCollection with: self ] ifFalse: [
		children flatCollect: [ :child | child allChildAtLevel: level currentLevel: currentLevel + 1 ]
	].
	
	

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
GncInnerNode >> removeChild: child [

	| childSize|

	childSize := child treeSize.
	children remove: child ifAbsent: [  Error signal: 'Trying to remove a wrong child' ].
	child parent: nil. 
	self updateTreeSize: (self treeSize - childSize ).
]

{ #category : '*Ume' }
GncInnerNode >> removeChildAt: index [ 

	| child childSize |
	
	child := children at: index.
	childSize := child treeSize. 

	children removeAt: index.
	treeSize := (treeSize - childSize)  
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

{ #category : '*Ume' }
GncInnerNode >> treeSize: size [

	treeSize := size 
]
