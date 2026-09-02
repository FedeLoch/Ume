#!/bin/bash

# run-all-parallel.sh
# Launches Pharo experiments in parallel, each downloading its own environment.

scripts=(
    # All schedulers with all mutators 100 seeds
    "run-regexes-weighted-scheduling.st"
    "run-regexes-random-scheduling.st"
    "run-regexes-mopt-scheduling.st"

    # All schedulers with all mutators 2 seeds
    "run-regexes-weighted-scheduling-2-seeds.st"
    "run-regexes-random-scheduling-2-seeds.st"
    "run-regexes-mopt-scheduling-2-seeds.st"

    # All schedulers with only grammar mutators 100 seeds
    "run-regexes-weighted-grammar-mutators-scheduling.st"
    "run-regexes-random-grammar-mutators-scheduling.st"
    "run-regexes-mopt-grammar-mutators-scheduling.st"

    # All schedulers with only grammar mutators 2 seeds
    "run-regexes-weighted-grammar-mutators-scheduling-2-seeds.st"
    "run-regexes-random-grammar-mutators-scheduling-2-seeds.st"
    "run-regexes-mopt-grammar-mutators-scheduling-2-seeds.st"
)

folders=(
    "regexes-weighted-scheduling-100-seeds"
    "regexes-random-scheduling-100-seeds"
    "regexes-mopt-scheduling-100-seeds"

    "regexes-weighted-scheduling-2-seeds"
    "regexes-random-scheduling-2-seeds"
    "regexes-mopt-scheduling-2-seeds"

    "regexes-weighted-grammar-mutators-scheduling-100-seeds"
    "regexes-random-grammar-mutators-scheduling-100-seeds"
    "regexes-mopt-grammar-mutators-scheduling-100-seeds"

    "regexes-weighted-grammar-mutators-scheduling-2-seeds"
    "regexes-random-grammar-mutators-scheduling-2-seeds"
    "regexes-mopt-grammar-mutators-scheduling-2-seeds"
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
