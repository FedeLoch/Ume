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
		(regex asRegex matches: regex minimalStringMatching)
	].
	tests := { 'ac?ab?ab?b?aa.?aaab?c?a(c)?ac?aaab?a?a'.
	         'ac?ab?ab|.b?aa.?aaab?c?a(ca)?ac?aaab?a?a'.
	         'a.?aa?aaa.b?aa.?aaa*a|a?a(c)?aa?|a*a|a?a'.
	         'ac.aaa+a?.c?aa.?a+a*a?a+a(c)?aa.aa+aaa?a'.
	         'ac?aaa+a?.c?aa.?aaa*a?a+a(c)?aa?aa+aaa?a'.
	         'ac?c*a+a?.c?aa.?aaa*a?a+a(c)?aa?aa+aaaba'.
	         'ac?aaaaa?.c?aa.?aaa*a?a+a(c)?aa?aa+aaa?a'.
	         'ac?aaa+a?.c?aaa?aaa*a?a?a(c)?aa?aa?aaa?a' } collect: [ :regex |
					ShrinkerTest input: regex oracle: oracle
				]
]
