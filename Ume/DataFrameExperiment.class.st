Class {
	#name : 'DataFrameExperiment',
	#superclass : 'GrammarBasePathologicalBugMutatorPaperExperiment',
	#category : 'Ume-Paper Experimentation',
	#package : 'Ume',
	#tag : 'Paper Experimentation'
}

{ #category : 'running' }
DataFrameExperiment >> maxInputSize [

	^ 200
]

{ #category : 'running' }
DataFrameExperiment >> methodsToInstrument [

	^ DataFrame package methods
]

{ #category : 'running' }
DataFrameExperiment >> name [

	^ 'DataFrame'
]

{ #category : 'running' }
DataFrameExperiment >> newGrammar [

	^ CSVGrammar new
]

{ #category : 'running' }
DataFrameExperiment >> schemaCorpusWith: mutators selector: selector [

	| csvGenerator |
	
	csvGenerator := UmeCorpusGenerator new
		  seeds: self seeds deepCopy;
		  mutationsPerIteration: self mpi;
		  mutators: mutators;
		  mutatorSelector: selector;
		  heuristic: UmePickBestElementDifferenceHeuristic new.
	
	^ UmeSchema new
		  receiverConstraint: (UmeObjectConstraint new generator: (UmeConstantGenerator new value: DataFrame));
		  argumentConstraints: { (UmeObjectConstraint new
				   generator: csvGenerator;
				   wrap: [ :input |
						   | file |
						   file := FileLocator temp / input hash asString , '.csv'.
						   file ensureDelete.
						   file writeStreamDo: [ :stream | stream nextPutAll: input ].
						   file asFileReference ];
				   unwrap: #contents) };
		  property: [ :regex :input :result | true ]
]

{ #category : 'running' }
DataFrameExperiment >> seeds [
	"Auto Generated but hardcoded to allow repetition"

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

	"	^ { 'a' . 'id,first_name,last_name,email,gender,ip_address
1,Jeannine,Sutehall,jsutehall0@lulu.com,Female,250.29.137.240
2,Lynnette,Pashbee,lpashbee1@blogger.com,Female,179.86.141.239
3,Garrick,Fontell,gfontell2@sitemeter.com,Male,4.57.36.151
4,Osbert,O''Henecan,oohenecan3@senate.gov,Male,251.160.81.243
5,Doug,Vieyra,dvieyra4@chronoengine.com,Genderfluid,72.234.190.220' }"
]

{ #category : 'running' }
DataFrameExperiment >> targetMethod [

	^ DataFrame class >> #readFromCsv:
]

{ #category : 'running' }
DataFrameExperiment >> weightedGrammarSchema [

	| csvGenerator |
	
	csvGenerator := UmeGrammarGenerator new grammar: self newGrammar; maxSize: self maxInputSize.
	
	^ UmeSchema new
		  receiverConstraint: (UmeObjectConstraint new generator: (UmeConstantGenerator new value: DataFrame));
		  argumentConstraints: { (UmeObjectConstraint new
				   generator: csvGenerator;
				   wrap: [ :input |
						   | file |
						   file := FileLocator temp / input hash asString , '.csv'.
						   file ensureDelete.
						   file writeStreamDo: [ :stream | stream nextPutAll: input ].
						   file asFileReference ];
				   unwrap: #contents) };
		  assert: [ :regex :input :result | true ]
]
