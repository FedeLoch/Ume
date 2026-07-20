#!/bin/bash

# run-all-parallel.sh
# Launches Pharo experiments in parallel, each downloading its own environment.

scripts=(
    "run-svg-grammar-derivations.st"
    "run-svg-grammar-literals.st"
    "run-svg-stochastic-base.st"
    "run-svg-weighted-grammar-base.st"
    "run-svg-weighted-scheduling.st"
    "run-svg-random-scheduling.st"
    "run-svg-mopt-scheduling.st"
)

folders=(
    "svg-grammar-derivations"
    "svg-grammar-literals"
    "svg-stochastic-base"
    "svg-weighted-grammar-base"
    "svg-weighted-scheduling"
    "svg-random-scheduling"
    "svg-mopt-scheduling"
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
