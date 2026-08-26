Class {
	#name : 'UmeShrinkingMicrodownCoverageBenchmark',
	#superclass : 'UmeShrinkingBenchmark',
	#category : 'Ume-Shrinking Benchmarks',
	#package : 'Ume',
	#tag : 'Shrinking Benchmarks'
}

{ #category : 'initialization' }
UmeShrinkingMicrodownCoverageBenchmark >> initialize [

	| oracle |
	super initialize.
	grammar := ExtendedMarkdownGrammar new.
	oracle := UmeCoverageOracle new
		          methodsToInstrument: Microdown package methods;
		          evalBlock: [ :input | Microdown parse: input ].

	tests := #( 'a' '# Header\r\t** This is a line comment **\r\t\r\t```\r\tcode\r\t```\r   \r   \t![Pharo is cool](http://pharo.org)\r\t\r   \t- list\r   \t1. ordered list \r\r  \t`in text` and for Pharo hyperlinks to class, method and package: \r  \t`Point`, `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`\r\r  \tReferences: @ref@'
	            '# Header\r\t** This is a line comment **\r\t\r\t```\r\tcode\r\t```\r   \r   \t![Pharo 0[^ cool](http://pharo.org)\r\t\r   \t- list\r   \t1. ordered list \r\r  \t`in text` and for Pharo hyperlinks to class, method and package: \r  \t`Point`& `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`\r\r  \tReferences: @ref@'
	            '# Header\r\t** This is a line comment **\r\t\r\t```\r\tcode\r\t```\r   \r   \t![Pharo 0[^ cool](nttp://pharo.org)\r\t\r   \t- list\r   \t1. ordered list \r\r  \t`in text` and for Pharo hyperlinks to class, method and pac&age: \r  \t`Point`\r `Point class`, `Point>>#setX:setY:`, `#’Microdown-Tests’`\r\r  \tReferences: @ref@'
	            '# Header\r\t** This is a line comment **\r\t\r\t```\r\tcode\r\t```\r   \r   \t![Pharo 0[^ cool](nttp://pharo.org)\r\t\r   \t- list\r   \t1. ordered list \r\r  \t`in text` and for Pharo hyperlinks to cyass, method and pac&age: \r  \t`Point`\r `Point class`, `PoinT>>#setX:setY:`, `#’Microdown-Tests’`\r\r( \tReferences: @ref@'
	            '4.\raj:#w m:.\r\r\r   \repvRd\r~zj\\n~ \r\r\r\t\r [:wq/a  #cdrk ](Ucd/eC- c)>\r![ja>:R/](eb)\t> gdb\\cgrhfh#jhnueN/Lwlyn’eg\r  \r - qewqyqReFicw\r  \t\t\t###\rxib-\r  4. -kMz/y   rz>ox:baxm'
	            '4.\raj:#w *m:.\r##\r\r   \repvRd\r~zj\\n~ \r\r\r\t\r [:wq/a  #cdrk ](Ucd/eC- c)>\r![ja>:R/]#(eb)\t> gdb\\cgrhfh#jhnueN/Lwlyn’eg\r  \r - qewqyqReFicw\r  \t\t\t###\rxib-\r  4. -kMz/y   rz>ox:baxm'
	            '4.\raj:#w *m:.\r##\r\r+   \repvRd\r~zj\\n~ \r\r\r-\t\r [:wq/a  #cdrk ](Ucd/eC- c)>\r![ja>:R/]#(eb)\t> gdb\\cgrhfh#jyhnueN/Lwlyn’eg\r  \r - qewqyqReFicw\r  \t\t\t###\rxib-\r  4. -kMz/y   rz>ox:baxm'
	            '1.\rupbf\\\r\t\r**:#\\ksbmlMb**[i>O](y.Z,pw)\r~~\\fpr~~ \r@UaKkap/’@@l:p@\r\r   \r `z`\t---\r|bxs|\r| ----------- |\r|chl./qk lg|\r\r\r\r>  >\\s Jzx.-bn txyqrvifn{#/>-vnK #od\\>gvw}:./ p/ww  '
	            '1.\rupbf\\\r\t\r**:#\\ksbmlMb**[lb.c](ampld x)\r~~\\fpr~~ \r@UaKkap/’@@l:p@\r\r   \r `z`\t---\r|bxs|\r| ----------- |\r|chl./qk lg|\r\r\r\r>  >\\s Jzx.-bn txyqrvifn{#/>-vnK #od\\>gvw}:./ p/ww  '
	            '1.\rupbf\\\r\t\r**:#\\ksbmlMb*2#*[lb.c](ampld x)\r~~\\fpr~~ \r@UaKkap/’@@l:p@\r\r   \r `z`\t---\r|bxs|\r| ----------- |\r|chl./qk lg|\r\r\r\r>  >\\s Jzx.-bn txyqrvifn{#/>-vnK #od\\>gvw-}:./ p/ww  '
	            '9.\rxor.rG\r**\\nhIezsbp**[G-zf ](xj> yl:/o )\r```\t\r \r\rb#u  \r\r\t```[^54]: s\\aw\r- k\\c/-d xy w,# jhot\t\r\r  >\r\\>>gogwmzciyiW\t\r\r~.kx/~\r--- \r > >d'
	            '9.\rxor.rG\r**\\XnhIezsbp**[G-zf ](xj>) yl:/o )\r```\t\r \r2\rb#u  \r\r\t```[^54]: s\\aw\r- k\\c/-d xy w,# jhot\t\r\r  >\r\\>>gogwmzciyiW\t\r\r~.kx/~\r--- \r > >d'
	            '9.\rqdx\\.\\\\\r**v.#\\> **[ \\/>/,-y](o>> --’y/: )```\t\t\r\t\r\r```- [ ]\r\\\\\\:\t- \\>\rB,>>-/ \t\r~~L.G/>t~~1.\r/ --h\t[^77]: :  l'
	            '9.\rqdx\\.\\\\\r**v.#\\> **[ \\/)>/,-y](o>> --’y/: )```\t\t\r\t\r\r```- [ ]\r\\\\\\:\t- \\>\rB,>>j-/ \t\r~~DL.G/>t~~1.\r/ --h\t[^77]: :  l'
	            '9.\rqdx\\.\\\\\r**v.#\\> [ ]**[^[ \\/)>/,-y](o>> --’y/: )```\t\t\r\t\r\r```- [ ]\r\\\\\\:\t- \\>\rB,>>#j-/ \t\r~~DL.G/>t~~1.\r/ --h\t[^77]: :  l'
	            '9.\roy#t\\\\\r@:.i\\:u@[iojTp - w/trml>-cv](#, /->nfq . t.ezgx.wl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jrOZ)--- | xl’\\pmlp.d:lt b|h:ctlkhya.yg| k> |\r| ----------- |\r|b/ c’|\r[^07]: >>6. fura'
	            '9.\roy#t\\\\\r@:.i\\:u@[iojTp - w/t/rml>-cv](#, /->nfq . t.ezgx.wl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jr<OZ)--- | xl’\\pmlp.d:lt b|h:ctlkhya~.yg| k> |\r| ----------- |\r|b/ c’|\r[^07]: >>6. fura'
	            '9.\roy#t\\\\\r@:.i\\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jr<OZ)--- | xl’\\pmlp.d:lt b|h:ctlkhya~.yg| k> |\r| ----------- |\r|b/ c’|\r[^0[^7]: >>6z. fura'
	            '9.\roy#t\\\\\r@:.i\\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jr<OZ)-\t-- | xl’\\pmlp.d:lt\r b|h:ctlkhya~.yg| k> |\r| ----------- |\r|b/ c’|\r[^0[^v7]: >>6z. fura'
	            '9.\roy#t\\\\\r@:.i\\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jr<OZ)-\t-- | xl’\\pmlp.d:)lt\r b|h:ctlkhya~.yg| k> |\r| -------~~---- |\r|b/ c’|\r[^0[^v7]: >>6z. fur7a'
	            '9.\roy#t\\U\\\rt@:.i\\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ezgx.wl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jr<OZ)-\t-- | xl’\\pmlp.d:)lt\r b|h:ctlkh7ya~.yg| k> |\r| -------~~---- |\r|b/ c’|\r[^0[^v7]: >>6z. fur7a'
	            '9.\roy#t\\U\\\r=@:.i\\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ez| -----------gxfwl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jr<OZ)-\t-- | xl’\\pmlp.d:)lt\r b|h:ctlkh7ya~.yg| k> |\r| -------~~---- |\r|b/ c’|\r[^0[^v7]: >>6z. fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ez| -----------gxfwl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.jr<OZ)-\t-- | xl’\\pmlp.d:)lt\r b|h:ctlkh7y-~.yg| v> |\r| -------~~---- |\r|b/ c’|\r[^0[^v7]: >>6z. fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/t/rml>-cv](t#, /->nfq . t.ez| -----------gxfwl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.j\r<OZ)-\t-- | xl’\\pmlp.d:)lt\r b|h:ctlkh7y-~.yg| v> |\r| -------~~---- |\r|b/ c’|\r[^0[^v7]: >>6zS fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/t/rml>-[^v](t#, /->nfq . t.ez| -----------gxfwl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.j\r<OZ)-\t-- | xl’\\pmlp.d:)lt\r b|h:ctlkh7y-~.yg| v> |\r| --’----~~---- |\r|b/ c’|\r[^0[^v7]: >>6zS fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/t/**ml>-[^v](t#, /->nfq . t.ez| -----------gxfwl)\r```\t\t\t\r \r```@\\V@f\r\t![g](.j\r<OZ)-\t-- | xl’\\pmlp.d:)lt\r b|h**ctlkh7y-~.yg| v> |\r| --’----~~---- |\r\rb/ c’|\r[^0[^v7]: >>6zS fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| -----------gxfwl)\r```\t\t\t\r \r```@\\V@f\r\t!,g](.j\r<OZ)0\t-- | xl’\\pmlp.d:)lt\r b|h**ctlkh7y-~.yg| v> |\r| --’----~~---- |\r\rb/ c’|\r[^0[^v7]: >>6zS fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| -----------gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t!,g](.j\r<OZ)0\t-- |```xl’\\pmlp.d:)lt\r b|h**ctlkh7y-~.yg| v> |\r| --’----~~---- |\r\rb/ c’|\r[^0[^v7]: >>6z4 fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| \r----------gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t!,g](.j\r<OZ)0\t-- |```xl’\\pmlp.d:)lt\r b`h**ctlkh7y-~.yg| v# |\r| --’----~~---- |\r\rb/ c’|\r[^0[^v7]: >>6z4 fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . t.ez| \r----------gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t!,g](.j\r&OZ)0\t-- |```xl’\\pmlp.d:)lt\r b`h**ctlkh7y-~.yg| v# |\r| --’----~~-f-- |\r\rb/ c’|\r@^0[^v7]: >>6z4 fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/tv**ml>-[^v](t#, /->nfq . twez| \r----------gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ)0\t-- |```xl’\\pmlp.1:)lt\r b`h**ctlkh7y-~.yg| v# |\r| --’----~~---- |\r\rb/ c’|\r[^0[^v7]: >>6z4 fur7a'
	            '9.\r<y#t\\p\\\r=@:.i\\:u@[iojmp - w/tv**ml>-[^v](t#, /->nfq . twez| \r----------gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ)0\t-- |```xl’\\pmlp.1:)lt\r b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r\rb/ c’|\r[^0[^v7]: >>6z4 fur7a'
	            '9.\r<y#t\\U\\\r=@:.i\\:u@[iojTp - w/tv**ml>-[^v](t#, /2>nfq . t.ez| \r----------gxf(l)\r```\t\t\t\r \r```@\\V@f\r###!,g](.j\r&OZ)0\t-- |```xl’\\pmlp.d:)lt\r b`h**ctlkh7y-~.yg| v# |\r| --’----~~-f-- |\r\rb/ c’|\r@^0[^v7]: >>6z4 fuQ7a'
	            '9.\r<y#t\\p\\\r=@:.i\\:u4[iojmp - w/tv**ml>-[^v](t#, /->nfq . twez| \r-----%----gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ)0\t-- |```xl’\\pmlp.1:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r\rb/ c’|\r[^0[^v7]: >>6z4 fur7a'
	            '9.\r<y#t\\p\\\r=@:.i\\:u4[iojmp - w/tv**ml>-[^v](t#, /->nfq . tw\rz| \r-----%----gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ)0\t-- |```xl’\\pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r\rb/ c’|\r)^0[^v7]: >>6z4 fur7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm! - w/tv**ml>-[^vY(t#, /->nfq . tw\rz| \r-----%----gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ)0\t-- |```xl’\\pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r\rb/ c’|\r)^0[^v7]: >>6z4 fur7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm! - w/tv**mK>-[^vY(t#, /->nfq . tw\rz| \r-----%--m-gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ#0\t-- |```xl’\\pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r\rb/ c’|\r)^0[^v7]: >>6z4 fur7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm! - w/tv**mK>-[^vY(t#, /->nfq . tw\rz| \r-----%--m-gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ#0\t-- |```xl(\\pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r#b/ c’|\r)^0[^v7]: >>6z4 fu<7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . tw\rz|\r\r-----%--m-gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j\r<OZ#0\t-- |```xl(\\pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r#b/ c’|\r)^0[^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . tw\rz|\r\r-----%--m-gxf(l)\r```\t\t\t\r \r```@\\V@f\r\t![^g](.j)<OZ#0\t-- |```xl(’pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r#b/ c’|\r)^0[^v7]: >>6z- fu**7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . tw\rz|\r\r-----%--m-gxf(l)\r```\t&\t\r \r```@\\V@f\r\t![^g](.j)<xZ#0\t-- |```xl(’pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r#b/ c’|\r)!0[^v7]: >>6z- fu**7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm!a- w/tv**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-----%--m-gxf(l)\r```\t\t\t\r \r```@\\V@>\r\t![^g](.j\r<OZ#0\t-- |```xl(\\pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v#\r|\r| --’----~~---- |\r#b/ c’|\r)^```[^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-----%--m-gxf(l)\r```\t\t\t\r \r```@\\V@>\r\t![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.```:)lt\r%b`h**ctlkh7y-~.yg| v%\r|\r| --’----~~---- |\r#b/ c’|\r)^```[^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\p\\\r=@:.i\\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-----%--m-gx[ ](l)\r```\t\t\t\r \r```@\\V@>\r\t![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.``?:)lt\r%b`h**ctlkh7y-~.yg| v%\r|\r| --’----q~---- |\r#b/ c’|\r)^```[^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:.i\\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-----%--m-gx[ ](l)\r```\t\t\t\r \r```@\\V@>\r\t![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.``?:)lt\r%b`h**ctlkh7y-~.yg| v%\r- \r| --’----q~---- |\r#b/ c’|\r)^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-----%--m-gx[ ](l)\r```\t\t\t\r \r```@\\V@>\r[^![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.``?:)lt\r%b`h**ctlkh7y-~.yg| v%\r- \r| --’----q~---- |\r#b/ c’|\r)^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\:u4[iojm!a- w/,v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-----%--m-gx[ ](/)\r```\t\t\t\r \r```@\\V@>\r[^![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.``?:)lt\r%b`h**ctlkh7y-~.yg| v%**- \r| --’----q~---- |\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\:u4[iojm!a- w/1v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-----%--m-gx[ ](/)\r```\t\r\t\r \r```@\\V@>\r[^![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.``?:)lt\r%b`h**ctlkh7y-~.yg| v%**- \r| --’----qj---- |\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\:u4[iojm!aj w/1v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-[---%--m-gx[ ](/)\r```\t\r\t\r \r```@\\V@>\r[^![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.``?:)lt\r%b`h**ctlkh7y-~.yg| v%*\r- \r| --’----qj---- |\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\(u4[iojm!aj w/1v**mK>-[^vY(t#, /->nfq . dw\rz|\r\r-[---%--m-gx, ](/)\r```\t\r\t\r \r```@\\V@>\r[^![^g](.j\r<OZ#0\t-- |```xl%\\pmlp.``?:)lt\r%b`h**ctlkh7y-~.yg| v%*\r- \r| --’----q9---- |\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw\rz|\r\r-[---%--m-gx, ](/)\r```\t\r\t\r \r```@\\\r@>\r[^![^g](.j\r<OZ#0\t-- |```xl%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.yg| v%*\r- \r| --’----q9---- |\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw\rz|\r\r-[-}-%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[^![^g](.j\r<OZ#0\t-- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.yg| v%*\r- \r| --’----q9---- |\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!#t\\)\\\r=@:VZ\\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw\rz|\r\r-[-}-%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[}![^g](.j\r<OZ#0\t-- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’----q9----\r|\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!%t\\)\\\r=@:VZ\\(u4[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw\rz|\r\r-[2}-%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[}![^g](.j\r<OZ#0\tU- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’----q9----\r|\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!%t\\)\\\r=@:VZ\\(uL[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[}![^g](.j\r<OZ#0\tU- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9----\r|\r#b/ c’|\ra^```]^v7]: >>6z- fu<7a'
	            '9.\r<!%t\\)\\\r=@:VZ\\(uL[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . dw\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[}![^g](.j\r<OZ#0\tU- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%--\r{#\r#b/ c’|\ra^```]^v7]: >>68- fu<7a'
	            '9.\r<!%t\\)\\\r=&:VZ\\(uL[iojm!aj w/1v**mK>-h^vY(t#, /->nfq . **k\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[}![^g](.j\r<OZ#0\tU- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%--\r{#\r#b/ c’|\ra^```]^v7]: >>68- fu<7a'
	            '9.\r<!%O\\)\\\r=&:VZ\\(uL[iojm!aj w/1v**mK>-h^!Y(t#, /->nfq . **k\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[}![^g](.j\r<OZ#0\tU- |```xE%\\pmlp..`?:mlt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%--\r{#\r#b/ c’|\ra^```]^v7]: >>68- fu<7a'
	            '9.\r<!%t\\)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^vY(t#, /->nfq . **k\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r@>\r[}![^g](.j\r<)Z#0\tU- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```]^v7]: >>68- fu<7a'
	            '9.\r<!%t\\)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r###>\r[}![^g](.j\r<)Z#0\tU- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```]^v7]: >>68- fu<7a'
	            '9.\r<!%|\\)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r###>\r[}![^g](.j\r<)Z#0\tU- |```xE%\\pmlp..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```]^ve]: >>68- .u<7a'
	            '9.\r<!%|\\)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k\rz|\r\r-[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r###>\r[}![^g](]: j\r<)Z#0\tU- |```xE%\\pml&..`?:)lt\r%b`h**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```]^ve]: >>68K .u<7a'
	            '9.\r<!%|\\)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k\r@|\r\rV[2}[%--m-=x, ](/)\r```\t\r\t\r \r```@\\\r###>\r[}![^g](]: j\r<)Z#0\tU- |```xE%\\pml&..`?:)lt\r%b`S**ctlkh7y-~.y0| v%*\r- \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```]^ve]: >>68K .u<7a'
	            '9.\r<!%|\\)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k\r@|\r\rV[2}[%--m-=v, ](/)\r```\t\r\t\r \r```@\\\r###>\r[}![^g](]: j\r<)Z#0\tU- |```xE%\\pml&..`?])lt\r%b`S**ctlkh7y-~.y0| \r%*\r- \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```]^ve]: >>68K .u<7a'
	            '9.\r<!%|\\)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^vY(t#,!/->nfq . *:k\r@|\r\rV[2}[%--m-=v, ](/)\r```\t\r\t\r \r```@\\\r###>\r[}![^g](]: j\r<)Z#0\tU- |```xE%\\pml&..`?])lt\r%b`S**ctlkh7yO~.y0| \r%*\r> \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```m^ve]: >>68K .u<7a'
	            '9.\r<!%|0)\\\r=&:VZ\\(uL[io#m!aj w/1v**mK>-h^| -----------Y(t#,!/->nfq . *:k\r@|\r\rV[2}[%--m-=v, ](/)\r```\t\r\t\r \r```@\\\r###>\r[}![^g](]: j\r<)Z#0\tU- |```xE%\\pml&..`?])lt\r%b`S**ctlkh7yO~.y0| \r- *\r> \r| --’---&q9-%-t\r{#\r#b/ c’|\ra^```m^ve]: >>68K .u<7a' )
		         collect: [ :input | ShrinkerTest input: input oracle: oracle ]
]
