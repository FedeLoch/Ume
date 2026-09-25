#!/bin/bash

# run-all-parallel.sh
# Launches Pharo experiments in parallel, each downloading its own environment.

scripts=(

    # All baselines - 100 seeds
    "run-svg-grammar-derivations.st"
    "run-svg-grammar-literals.st"
    "run-svg-stochastic-base.st"

    # All baselines - 2 seeds
    "run-svg-grammar-derivations-2-seeds.st"
    "run-svg-grammar-literals-2-seeds.st"
    "run-svg-stochastic-base-2-seeds.st"

    # All schedulers with all mutators 100 seeds
    "run-svg-random-scheduling.st"
    "run-svg-mopt-scheduling.st"

    # All schedulers with all mutators 2 seeds
    "run-svg-random-scheduling-2-seeds.st"
    "run-svg-mopt-scheduling-2-seeds.st"

    # All schedulers with only grammar mutators 100 seeds
    "run-svg-random-grammar-mutators-scheduling.st"
    "run-svg-mopt-grammar-mutators-scheduling.st"

    # All schedulers with only grammar mutators 2 seeds
    "run-svg-random-grammar-mutators-scheduling-2-seeds.st"
    "run-svg-mopt-grammar-mutators-scheduling-2-seeds.st"
)

folders=(
    # Each mutator isolated 100 seeds
    "svg-grammar-derivations-100-seeds"
    "svg-grammar-literals-100-seeds"
    "svg-stochastic-base-100-seeds"

    # Each mutator isolated 2 seeds
    "svg-grammar-derivations-2-seeds"
    "svg-grammar-literals-2-seeds"
    "svg-stochastic-base-2-seeds"

    # All schedulers with all mutators 100 seeds
    "run-svg-random-scheduling-100-seeds"
    "run-svg-mopt-scheduling-100-seeds"

    # All schedulers with all mutators 2 seeds
    "run-svg-random-scheduling-2-seeds"
    "run-svg-mopt-scheduling-2-seeds"

    # All schedulers with only grammar mutators 100 seeds
    "run-svg-random-grammar-mutators-scheduling-100-seeds"
    "run-svg-mopt-grammar-mutators-scheduling-100-seeds"

    # All schedulers with only grammar mutators 2 seeds
    "run-svg-random-grammar-mutators-scheduling-2-seeds"
    "run-svg-mopt-grammar-mutators-scheduling-2-seeds"
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
