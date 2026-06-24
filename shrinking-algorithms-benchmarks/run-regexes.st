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

benchmark2 := (Smalltalk at: #UmeShrinkingRegexBenchmark) for: shrinkerClasses.
report := benchmark2 bench.

report saveAsFile: 'UmeShrinkingRegexBenchmark.json'