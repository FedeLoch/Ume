Class {
	#name : 'UmeDataFrameCoverageTest',
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

{ #category : 'as yet unclassified' }
UmeDataFrameCoverageTest >> dataFrameFileGenerator [

	| csvGenerator |
	csvGenerator := UmeCorpusGenerator new
		                seeds: self seeds;
		                mutationsPerIteration: 3;
		                mutators: {
				                ((UmeGrammarLiteralsMutator from: CSVGrammar new) maxInputSize: 1000).
				                ((UmeGrammarDerivationMutator from: CSVGrammar new) maxInputSize: 1000) };
		                heuristic: UmePickBestElementDifferenceHeuristic new.


	^ UmeObjectConstraint new
		  generator: csvGenerator;
		  wrap: [ :input |
				  | file |
				  file := FileLocator temp / input hash asString , '.csv'.
				  file ensureDelete.
				  file writeStreamDo: [ :stream | stream nextPutAll: input ].
				  file asFileReference ];
		  unwrap: #contents
]

{ #category : 'running' }
UmeDataFrameCoverageTest >> seeds [

	^ #( '.#_
8,180,,' '’,true,true
 ' 'null
false
F. ,' 'true
3
null,null,false,true,null
.
210,true,5

null

false' 'null

,69799,_
t

true
07' 'true
z#-#,#\,/’' 'false,/
null,638
,:' ' ' '24' '@,
1,5' '1183
,' ',1543
_
019,null,null' 'null
04,3,64' 'false,#:’-' 'I/
78099' '
' 'false,:' 'false
@,' ',,null
true
true
5,null
0' '70
true,B
false,R#_-
@.' 'false,550' '9,>' '511,-,2,:H>--’.-,-@,
493,,,7' 'true
,null,87' ',:,9,' '30
944' '@' '348
,757
true
' '
,v,null' 'null,,9467' '3,' ',false,8,' ',,false,false' '-
6,057
\c,:,9,>,’’,_,./,4' 'true,7
’\@,.@,false' '4
false
-,>@’.' ':M.' '-' '''\
'',null
,true
true
94,null' '_,80
0
3' '
true,null,' '>>_'':>’
1,false

’’/-,6,2
479' '.>' '2,\#\>''_,5,0,false,
_,13,907,#,5173' ',false,true,' 'null
2,
' '.
’
4,\.N.'',
,null' 'false,757' '.,,#,false
k' 'false,4' '-/,' '\:

21,' '21
,03' '51' '''\,true

\@' '9,8' 'false,true,' ',67' 'true
null,false,true,919,null' '
6,8230
:
,780
''_\,,' 'null,,>#@’G:' '’,2' '8,,true
false
' ':' ':e_,##, '',' '92,.z,,false,’
59,true' 'B
  V''
,13,true,2' ',,85550628,' ',,/_T_,’’,true,, 
153,2' 'null,true,7875
false' '0
true,,,''#::,
true
:
,true,-,Js' '7

true,true,false,,45' '84' 'true,974' ',5,false' ':,' '2,,false,8,-,null' '173' '''' '#_/’
 :,' '2
true,,\#,7' ',\/_’,null,249
88
1,true
,-,true
null' '-,true,
,null,,-' '@\:''' ',
>
,false
null,2
null
63,,:.h
true

’:Jv
74,6,:' 'null,null,' '
false,,3
/b,null' '\' 'null,,>,6769,true' ',9,,' '/-,,#,:,31
1,true' 'null,null,6,true,9' '9,false' '9
55' 'K@#_,
0,.' '_\_U
null,'',-

\>,null
@.''w,-,/__ 
_,false' '_@ s_,
-g-/''
_F>/>#b-,false,,,null,,
-,,q,8,false
false
.@' 'true,45,4' '248' 'true
true,0' )
]

{ #category : 'running' }
UmeDataFrameCoverageTest >> setUp [

	super setUp.
	self timeLimit: 5 hours.
	
	schema := UmeSchema new
		          receiverConstraint: (UmeConstantGenerator new value: DataFrame);
		          argumentConstraints: { self dataFrameFileGenerator };
		          property: [ :regex :input :result | true ];
					 method: DataFrame class >> #readFromCsv:.

	runner := UmeRunner test: schema for: 1 hour.
]

{ #category : 'tests' }
UmeDataFrameCoverageTest >> testGuidingByCoverage [

	| result methods |
	
	runner guidedByCoverage.
	methods := DataFrame package methods.
	"runner collectAllCases."
	runner collectOnlyOutliers.
	
	runner methodsToInstrument: methods.
	result := runner run.

	1 halt.
]
