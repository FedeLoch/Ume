#!/bin/bash

# run-all-parallel.sh
# Launches Pharo experiments in parallel, each downloading its own environment.

scripts=(

    # All baselines - 100 seeds
    "run-graph-grammar-derivations.st"
    "run-graph-grammar-literals.st"
    "run-graph-stochastic-base.st"

    # All baselines - 2 seeds
    "run-graph-grammar-derivations-2-seeds.st"
    "run-graph-grammar-literals-2-seeds.st"
    "run-graph-stochastic-base-2-seeds.st"

    # All schedulers with all mutators 100 seeds
    "run-graph-random-scheduling.st"
    "run-graph-mopt-scheduling.st"

    # All schedulers with all mutators 2 seeds
    "run-graph-random-scheduling-2-seeds.st"
    "run-graph-mopt-scheduling-2-seeds.st"

    # All schedulers with only grammar mutators 100 seeds
    "run-graph-random-grammar-mutators-scheduling.st"
    "run-graph-mopt-grammar-mutators-scheduling.st"

    # All schedulers with only grammar mutators 2 seeds
    "run-graph-random-grammar-mutators-scheduling-2-seeds.st"
    "run-graph-mopt-grammar-mutators-scheduling-2-seeds.st"
)

folders=(
    # Each mutator isolated 100 seeds
    "graph-grammar-derivations-100-seeds"
    "graph-grammar-literals-100-seeds"
    "graph-stochastic-base-100-seeds"

    # Each mutator isolated 2 seeds
    "graph-grammar-derivations-2-seeds"
    "graph-grammar-literals-2-seeds"
    "graph-stochastic-base-2-seeds"

    # All schedulers with all mutators 100 seeds
    "run-graph-random-scheduling-100-seeds"
    "run-graph-mopt-scheduling-100-seeds"

    # All schedulers with all mutators 2 seeds
    "run-graph-random-scheduling-2-seeds"
    "run-graph-mopt-scheduling-2-seeds"

    # All schedulers with only grammar mutators 100 seeds
    "run-graph-random-grammar-mutators-scheduling-100-seeds"
    "run-graph-mopt-grammar-mutators-scheduling-100-seeds"

    # All schedulers with only grammar mutators 2 seeds
    "run-graph-random-grammar-mutators-scheduling-2-seeds"
    "run-graph-mopt-grammar-mutators-scheduling-2-seeds"
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
