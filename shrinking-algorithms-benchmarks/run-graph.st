| shrinkerClasses benchmark report |

Metacello new
    baseline: 'Ume';
    repository: 'github://FedeLoch/Ume:main';
	onConflictUseIncoming;
    load.

shrinkerClasses := {
    Smalltalk at: #UmeGRABRShrinker.
    Smalltalk at: #UmeDDminFuzzingBookShrinker.
    Smalltalk at: #UmeDDminPaperShrinker.
    Smalltalk at: #UmeNautilusShrinker.
    Smalltalk at: #UmeHDDShrinker.
    Smalltalk at: #UmeVulcanShrinker
}.

benchmark := (Smalltalk at: #UmeShrinkingGraphCoverageBenchmark) for: shrinkerClasses.
report := benchmark bench.

report saveAsFile: 'UmeShrinkingGraphCoverageBenchmark.json'