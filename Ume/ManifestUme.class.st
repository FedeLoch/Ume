"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestUme',
	#superclass : 'PackageManifest',
	#category : 'Ume-Manifest',
	#package : 'Ume',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestUme class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#UmeNautilusShrinker #candidates: #false)) #'2026-06-17T10:25:57.033098+02:00') )
]

{ #category : 'code-critics' }
ManifestUme class >> ruleModifiesCollectionRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#UmeMOPTMutatorSelector)) #'2026-07-01T15:23:59.044454+02:00') )
]

{ #category : 'code-critics' }
ManifestUme class >> ruleReIsNotNilAndConditionalRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#UmeNautilusShrinker #minimizeOne:upperBound: #false)) #'2026-06-17T10:24:47.051485+02:00') #(#(#RGClassDefinition #(#UmeNautilusShrinker)) #'2026-06-17T10:25:15.980842+02:00') )
]

{ #category : 'code-critics' }
ManifestUme class >> ruleUnoptimizedToDoRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#UmeMOPTMutatorSelector #updateProbabilities #false)) #'2026-07-01T15:17:13.69196+02:00') #(#(#RGClassDefinition #(#UmeMOPTMutatorSelector)) #'2026-07-01T15:17:21.313483+02:00') )
]

{ #category : 'code-critics' }
ManifestUme class >> ruleWhileTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#UmeHDDShrinker #minimizeOne:upperBound: #false)) #'2026-07-29T11:28:29.575968+02:00') )
]
