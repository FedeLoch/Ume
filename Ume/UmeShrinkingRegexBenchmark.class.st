Class {
	#name : 'UmeShrinkingRegexBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'initialization' }
UmeShrinkingRegexBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := GncRegexGrammar new.
	oracle := PerformanceOracle new threshold: 0.95; evalBlock: [ :regex |
		regex asRegex matches: regex minimalStringMatching
	].

	tests := #(
					'b*c?c+' 'b*c?b+' 'b*bbc?b+' 'b*bbc|bc?b+' '(a)*.*.'
	            'b*(b|bc|bc?)b+' 'b*b(b|bc||bac?)b+' 'b*b(b|ba*||bac?)b+'
	            'b*b(b|b.*||bac?)b+' 'b*b(b|b.*|ba?.*c+bba+|)b+'
	            'b*b(b|b.*|b*|)b+' 'b*b(b|(bc.*|b*|))b+'
				) collect: [ :regex | ShrinkerTest input: regex oracle: oracle ]
]
