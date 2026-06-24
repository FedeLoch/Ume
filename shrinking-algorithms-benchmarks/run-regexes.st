| shrinkerClasses benchmark report |

Metacello new
    baseline: 'Ume';
    repository: 'github://FedeLoch/Ume:benchmark-new-cases';
	onConflictUseIncoming;
    load.

shrinkerClasses := {
    Smalltalk at: #UmeDeltaDebugger.
    Smalltalk at: #UmeGRABRShrinker.
    Smalltalk at: #UmeNautilusShrinker.
    Smalltalk at: #UmeHDDShrinker
}.

benchmark := (Smalltalk at: #UmeShrinkingRegexBenchmark) for: shrinkerClasses.
report := benchmark bench.

report saveAsFile: 'UmeShrinkingRegexBenchmark.json'