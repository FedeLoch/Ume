Class {
	#name : 'UmeWeightedMutatorSelector',
	#superclass : 'UmeMutatorSelector',
	#category : 'Ume-Selector Heuristics',
	#package : 'Ume',
	#tag : 'Selector Heuristics'
}

{ #category : 'enumerating' }
UmeWeightedMutatorSelector >> select: mutators [

	| totalWeights weights random cumulative |

	totalWeights := (mutators collect: #weight) sum.
	weights := OrderedCollection new.
	cumulative := 0.
    
    mutators do: [ :wrapper |
        cumulative := cumulative + wrapper weight.
        weights add: cumulative
    ].
	
	random := (1 to: totalWeights) atRandom.
	
	^ mutators at: (weights findFirst: [ :weight | random <= weight ])
]
