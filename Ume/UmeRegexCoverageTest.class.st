Class {
	#name : 'UmeRegexCoverageTest',
	#superclass : 'TestCase',
	#instVars : [
		'argumentConstraints',
		'schema',
		'receiverConstraint',
		'runner'
	],
	#category : 'Ume-Framework Tests',
	#package : 'Ume',
	#tag : 'Framework Tests'
}

{ #category : 'running' }
UmeRegexCoverageTest >> regexByProp: props and: feedback [

	| regex grammarConstraint |
	regex := nil.
	
	grammarConstraint := (props at: 'grammar').
	grammarConstraint feed: feedback.

	[ regex ] whileNil: [ [ | maybe |
		maybe := grammarConstraint gen.
		(UmeRegex fromString: maybe) compileRegex.
		regex := maybe ]
			on: Error
			do: [ :e | ^ regex ] ].

	^ regex
]

{ #category : 'running' }
UmeRegexCoverageTest >> seeds [

	^ #( '.?()*' '(|.*b*b+||a*|c*.?|a?|a?|.*)*|c?.?' 'a(.c?b+)|a?a+|a*|b?c*()+|(|a+)?(b*)' '|()*||' 'a(((.+().?)b+.+c*()+.+ba+)+|.b*)b?|c*||'
	     'a+|' 'b(|)*a*b*c+' 'b+||' 'c?|b+c+|' 'a+c?c' '.*|' 'b*|a*a+' '.*a*' '|((|)?((c?)+b|(b?|(|b+)+a?)?))?'
	     '|((a*a.+))b*c*||' '|bc*a+b+a+' '||(aa*|)+' '|c+|.|b?|b..*|((|)*|)*|a|' '|||a*.+a*' 'b+c?' 'c?aa+|(b?)+ca' 'a*|' '|ba+.*a*'
	     '|(())+||c?((||aa*(|a+)*)+)*|' '|()a+|a+.+||((c)*)?' '(|)c*.?||' '|b?b?((b)aa+|b?)?' 'b?b*.?.(a*)?||.*|c*|.?'
	     '|a?(b+)?' 'c?a*c*|(|c*)()*' '.+c?' '()?b*.' '(c*||.?)?.' 'b?|(c?)|' 'b+bc+' 'b+.*b|c?' 'b+bc||' 'a+.?' '|()c*' '|b*(||)+'
	     'c+.+|.+b?.c(..?)?((|a*|)?)+' 'c*b+c+|c+c?' '(.*a*||||)*|' '(a+c+(a+)+)*.+|c+b+' 'c*(||)*b*||b?c?' 'ccc*a*' '(|b?b(a*)*c+()*||||)?cc+'
	     '((||b)+a?b?()*|b+.*.+)?a*.?' 'b' 'cc+(.*(c?c)|)?.*c+(a*||b?c*)*.+a' 'b+.*' 'c+||ac' '.?c|' '().+a?b|.*a+b*|b|'
	     '(((a?|)?a?)+|)+' 'c+a?' '(.?b*|)b*' '.+' '|||aac' '.a*.?.*' '||.*.|' 'bc?' '||.?()?c*.+(c+||)?' '|b' 'cb+.+c' '|b+||'
	     '|.?.+' '.+c?b?' 'a*c' '(a*()()?|)+(|ba+|b)?b+(b+c||a+a+|)+a+|' '|||c+(b*)?' 'a()|' '||.?b*' '..+' '(c?(c)c?|b+.*)*((|.|()?a|)*c?|b)'
	     '.?|.?c+(ba)*c*||' '(|a|.)*a?b?' '|c+|' '(c..*||)+|b?' '(ac.?c+b?a?)?b*||.?' '.*b*|.b?c?(c+b*(a?b+|a*|b+a+b*)+|)?'
	     'b*.a*' '|||c*||b+.a?|c*' 'a*.+c.+(|)*c?c|||' '||||' 'a*.*c+.+' '|.?(.+.)a+' 'a+a*' '(|)?b?b?b?()*' '(||.*)+.*(|)*c*a+|a*'
	     '|' '(.|.c(a?|)+||(.?|)|c*.?c?)()*.?' 'ca+' '||a*.+()+' '..c*' 'a*c*|c+' 'b*b?|b+|' 'c*b+(|)?.+c+b+|a(|a+|a*b?b*a+c+||)*a|'
	     'b+b(b+c+a?)+|' 'b*b?|' )
]

{ #category : 'running' }
UmeRegexCoverageTest >> setUp [

	| regexGenerator sharedProperties regexConstraint |

	super setUp.
	self timeLimit: 5 hours.
	
	regexConstraint := UmeObjectConstraint new
		unwrap: [ :case | (case class = UmeRegex) ifTrue: [ case regexString ] ifFalse: [ case ] ];
		generator: (UmeCorpusGenerator new
		seeds: self seeds deepCopy;
		mutationsPerIteration: 3;
		mutators: {
			(UmeGrammarLiteralsMutator from: GncRegexGrammar new) maxInputSize: 1000.
			(UmeGrammarDerivationMutator from: GncRegexGrammar new) maxInputSize: 1000
		  };
		heuristic: UmePickBestElementDifferenceHeuristic new).
	
		sharedProperties := UmeInternalConstraintProperties
		from: { ('grammar' -> regexConstraint) } asDictionary.
	
	regexGenerator := UmeGenerator do: [ :props :feedback | | regex |
		regex := self regexByProp: props and: feedback.
		regex ifNil: [ nil ] ifNotNil: [ 
		props at: 'input' put: regex minimalStringMatching.
		UmeRegex fromString: regex  ] ].
	
	regexGenerator mutationMetadataBlock: [ (sharedProperties at: 'grammar') mutationMetadata ].
	
	receiverConstraint := UmeObjectConstraint new objectClass: RxMatcher;
		generator: regexGenerator;
		props: sharedProperties.
	
	argumentConstraints := {
		(UmeObjectConstraint new objectClass: String;
			props: sharedProperties;
			generator: (UmeGenerator do: [ :props :feedback | props dict at: 'input' ifAbsent:[ nil ] ]))
	}.
	
	schema := UmeSchema new
		          receiverConstraint: receiverConstraint;
		          argumentConstraints: argumentConstraints;
		          property: [ :regex :input :result | true ];
					 method: RxMatcher >> #matches:.

	runner := UmeRunner test: schema for: 1 hour.
]

{ #category : 'tests' }
UmeRegexCoverageTest >> testGuidingByCoverage [

	| result methods |
	
	runner guidedByCoverage.
	methods := RxMatcher package methods.
	"runner collectAllCases."
	runner collectOnlyOutliers.
	
	runner methodsToInstrument: methods.
	result := runner run.

	1 halt.
]
