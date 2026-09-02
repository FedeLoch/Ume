Metacello new
    baseline: 'Ume';
    repository: 'github://FedeLoch/Ume:main';
	onConflictUseIncoming;
    load.

(Smalltalk at: #GraphExperiment) run: 'weighted-scheduling' seeds: 2.