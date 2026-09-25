Metacello new
    baseline: 'Ume';
    repository: 'github://FedeLoch/Ume:main';
	onConflictUseIncoming;
    load.

(Smalltalk at: #SVGExperiment) run: 'random-scheduling-with-grammar-mutators' seeds: 2.