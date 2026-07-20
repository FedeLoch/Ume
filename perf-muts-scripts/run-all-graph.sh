#!/bin/bash

# run-all-parallel.sh
# Launches Pharo experiments in parallel, each downloading its own environment.

scripts=(
    "run-graph-grammar-derivations.st"
    "run-graph-grammar-literals.st"
    "run-graph-stochastic-base.st"
    "run-graph-weighted-grammar-base.st"
    "run-graph-weighted-scheduling.st"
    "run-graph-random-scheduling.st"
    "run-graph-mopt-scheduling.st"
)

folders=(
    "graph-grammar-derivations"
    "graph-grammar-literals"
    "graph-stochastic-base"
    "graph-weighted-grammar-base"
    "graph-weighted-scheduling"
    "graph-random-scheduling"
    "graph-mopt-scheduling"
)

BASE_DIR="$(pwd)"

for i in "${!scripts[@]}"; do
    script="${scripts[$i]}"
    run_dir="${folders[$i]}"
    
    echo "Queueing $script in isolated directory $run_dir"
    
    mkdir -p "$run_dir"
    (
        cd "$run_dir"
        ../run.sh "../$script" > "../$script.log" 2>&1
    ) &
done

echo "All experiments launched in parallel. Check *.log files for updates."
echo "Waiting for all processes to finish..."
wait
echo "All experiments finished."
