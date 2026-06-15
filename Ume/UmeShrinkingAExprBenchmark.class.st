Class {
	#name : 'UmeShrinkingAExprBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking',
	#package : 'Ume',
	#tag : 'Shrinking'
}

{ #category : 'initialization' }
UmeShrinkingAExprBenchmark >> initialize [

	super initialize.
	grammar := AritExpressionGrammar new.
	tests := {
		ShrinkerTest input: '1+(2*3)/0' oracle: DivideZeroOracle new.
	}
	"ShrinkerTest input: '1+(2*3)' oracle: (self oracleByBlock: [ :string | (string includesSubstring: '(3)' ) not]).
		ShrinkerTest input: '1+(2*3)' oracle: (self oracleByBlock: [ :string | (string includes: $1) not]).
		ShrinkerTest input: '1+(2*3)' oracle: (self oracleByBlock: [ :string | (string includesSubstring: '(3)' ) not]).
		ShrinkerTest input: '2*3' oracle: (self oracleByBlock: [ :string | (string includes: $3) not]).
		ShrinkerTest input: '3*2' oracle: (self oracleByBlock: [ :string | (string includes: $3) not]).
		ShrinkerTest input: '3' oracle: (self oracleByBlock: [ :string | (string includes: $3) not]).
		ShrinkerTest input: '1+(3)' oracle: (self oracleByBlock: [ :string | (string includesSubstring: '(' ) not]).
		ShrinkerTest input: '1+(3)' oracle: (self oracleByBlock: [ :string | (string includesSubstring: '4' ) not]).
		ShrinkerTest input: '1+(2*3)' oracle: (self oracleByBlock: [ :string | (string includesSubstring: '2' ) not])."
]

{ #category : 'initialization' }
UmeShrinkingAExprBenchmark >> oracleByBlock: block [

	^ UmeBooleanInputOracle from: block
]
