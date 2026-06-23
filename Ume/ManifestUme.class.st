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
ManifestUme class >> ruleReIsNotNilAndConditionalRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#UmeNautilusShrinker #minimizeOne:upperBound: #false)) #'2026-06-17T10:24:47.051485+02:00') #(#(#RGClassDefinition #(#UmeNautilusShrinker)) #'2026-06-17T10:25:15.980842+02:00') )
]
