Class {
	#name : 'UmeGRABRShrinker',
	#superclass : 'UmeGrammarShrinker',
	#instVars : [
		'reductionStrategy',
		'seen'
	],
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'shrinking' }
UmeGRABRShrinker >> asInput: tree [

	^ tree asInput
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> candidates: subTree matching: symbol [

	| allCandidates OrderedCandidates|
	
	"TODO: Improve performance here"
	allCandidates := (reductionStrategy reduce: subTree using: grammar matching: symbol) asSet.
	allCandidates difference: seen. 
	OrderedCandidates := allCandidates asOrderedCollection. 
	OrderedCandidates sort: [ :treeA :treeB | treeA treeSize  < treeB treeSize ]. 
	^ OrderedCandidates
]

{ #category : 'copying' }
UmeGRABRShrinker >> copyTree: tree [
 
	^ self tree: tree asInput
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> initialize [ 

	super initialize.
	seen := Set new.
	reductionStrategy := UmeSimplifyGrammarBoth.
	
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> minimizeOne: originalTree upperBound: bound [

	originalTree allNodes doWithIndex: [ :subTree :index |
		( subTree isLeaf ) ifFalse: [ | symbol |
			symbol := subTree tag. 
			( self candidates: subTree matching: symbol ) do: [ :candidate |
				seen add: candidate. 
				( candidate treeSize < originalTree treeSize) ifTrue: [ | newTree |
					newTree := self replaceSubtreeIn: originalTree by: candidate index: index.
					self minimizationDone.
					(self triggerBug: newTree upperBound: bound ) ifTrue: [
						^ newTree
					] ifFalse: [ self failedMinimization. ]
				]
			] 
		] 
	].
	
	^ originalTree
]

{ #category : 'accessing' }
UmeGRABRShrinker >> reductionStrategy [

	^ reductionStrategy
]

{ #category : 'accessing' }
UmeGRABRShrinker >> reductionStrategy: aStrategy [

	reductionStrategy := aStrategy
]

{ #category : 'copying' }
UmeGRABRShrinker >> replaceSubtreeIn: tree by: subtrees index: index [

	| treeCopy treeToMutate parent |

	treeCopy := self copyTree: tree.
	
	treeToMutate := treeCopy allNodes at: index.
	(treeToMutate isLeaf) ifTrue: [ ^ tree ].
	
	parent := treeToMutate parent. 
	parent ifNil: [ ^ subtrees ].
	
	parent children: ( parent children collect: [ :child |
		child == treeToMutate ifTrue: [ subtrees ] ifFalse: [ child ]
		]).
	
	^ treeCopy
]

{ #category : 'shrinking' }
UmeGRABRShrinker >> shouldStop: minimized size: size from: current size: currentSize [

	^ minimized = current
	
]
