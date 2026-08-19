Class {
	#name : 'UmeShrinkingRegexBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking Benchmarks',
	#package : 'Ume',
	#tag : 'Shrinking Benchmarks'
}

{ #category : 'initialization' }
UmeShrinkingRegexBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := GncRegexGrammar new.
	oracle := UmeMethodCallsOracle new
		threshold: 0.95;
		methodsToInstrument: RxMatcher package methods;
		evalBlock: [ :regex | regex asRegex matches: regex minimalStringMatching ].

	tests := #(
					'b*c?c+' 'b*c?b+' 'b*bbc?b+' 'b*bbc|bc?b+' '(a)*.*.'
	            'b*(b|bc|bc?)b+' 'b*b(b|bc||bac?)b+' 'b*b(b|ba*||bac?)b+'
	            'b*b(b|b.*||bac?)b+' 'b*b(b|b.*|ba?.*c+bba+|)b+'
	            'b*b(b|b.*|b*|)b+' 'b*b(b|(bc.*|b*|))b+'
					'b*(c|a*|||)(b|.+|b*b*)b+' 'b*(a((c?b.*))*.?|a*|||)(b|b?|b*b*)c+'
	            'b*(ac+a*.()c|.*|||)(b+|b?|b*b*)c+'
	            'b*(ac+a*.a?b*|.*|||)(|b*.|c+a+.*)b+'
	            'b*(acca+a*..()c|.*|||)(b+|b?|b*b*)c+'
	            'b.*(acca+a*..(.)c|.*|||)(b+|b?|cb*b*)c+'
	            'b.*(acca+a*..(.)c|.*||)(b+|cb?|ccb*b*)c+'
	            'b.*(acca+a*..(.)c|.*|||)(c.||c.*)()'
	            'b.*(acca+a*..(..+)c|.*|||)(c..||c.*)()'
	            'b.*(acca+a*..(.c)c|.*|||)(c..||c.*)(||())'
	            'b.*(acca+a*..(.c)c|.*|||)(c..||a.*)(||())'
	            'b.*(acca+a*..(.c)c|.*|||)(b+||a.*)(||c?)'
	            'b.*(acca+a*..(.c)c|.*|||)(c..||a.*)(||a*)'
	            "'a.*(ac.a+a*..(.c)c|.*|||)(c..||a.*)(||a*)'
	            'a.*(ac.a+a*..cc|.*|||)(c..||a.*)(()||||a+)'
	            'a.*(ac.a+a*..cc|.*|||)(c..||a.*)(()||||.+)'
	            'a.*(ac.a+a+c|.*|||)(c..||a.*)(|.*ba+()|a+|c*a+.?b+||)'
	            'a.*(ac.a+a*..cc|.*|||)(|(.*).*a*)(()||||b)'
	            'a.*(ac.a+a*..cc|.*|||)(|(.*).*a*)(()|||||)'
	            'a.*(ac.a+a*..cc|.*|||)(|(.*).*a*)(()|.*||(a*))'
	            'a.*(ac.a+a*..cc|.*|||)(|(.*).*a*)(c?.*|c?b?|||)'
	            'a.*(ac.a+a*..cc|.*|.|)(|(.*).*.*)(c?.*|c?b?|||)'
	            'a.*(cc.a+a*..cc|.*|c|)(|(.*).*.*)(cc|c?b?|||)'
	            'a.*(cc.a+a*..cc|.*|c|)(|(.*).*.*)(cc|c?b?|.*)'
	            'a.*(cc.a+a*..cc|.*|c|)(|()(.+|.)*.*)c'
	            'a.*(cc.a+a*..cbc|.*|c|)(b|.()(.+|.)*.*)c'
	            'a.*(cc.a.a*..cbc|.*|.|)(b|.()(.+|.)*.*)c'
	            'a.*(cc.a.a*..cbc|.|.|)(b|.*)(.+|.)*.*cc'
	            'a.*(cc.a.a*c.cbc|.|.|)(c|.*)(.+|.)*a.*cc'
	            'a.*(cc.a.a*c..cbc...|)(c|.*)(.+|.)*a.*cc'"
				) collect: [ :regex | ShrinkerTest input: regex oracle: oracle ]
]
