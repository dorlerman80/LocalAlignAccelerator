#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e "\e[31;1m>> Usage: $0 REPEAT\e[0m"
    exit 1
fi

REPEAT=$1

# Regression setup
REGRESSION_DIR="./regression_$(date +%Y-%m-%d_%H-%M-%S)"
COVERAGE_ROOT_DIR="$REGRESSION_DIR/coverage_all"
LOG_DIR="$REGRESSION_DIR/logs"
RESULTS_FILE="$REGRESSION_DIR/regression_results.txt"
FINAL_COVERAGE_DB="$COVERAGE_ROOT_DIR/merged_coverage.ucdb"
TESTS_DIR="$REGRESSION_DIR/tests"

mkdir -p "$COVERAGE_ROOT_DIR" "$LOG_DIR" "$TESTS_DIR"
> "$RESULTS_FILE"

# Compilation step
echo -e "\e[31;1m>> Starting RTL compilation...\e[0m"
make clean
make comp LOG_DIR="$LOG_DIR" || { echo -e "\e[31;1m>> Compilation failed. Aborting regression.\e[0m"; exit 1; }
echo -e "\e[31;1m>> Compilation completed.\e[0m"

# Format the results file
echo -e "Test Name               | Iteration | SEED        | CONFIG_PARAMS                                     | Result" >> "$RESULTS_FILE"

# Run tests
echo -e "\e[31;1m>> Starting regression with $REPEAT iterations...\e[0m"
for ((i = 1; i <= REPEAT; i++)); do
    echo -e "\e[31;1m>> Running test $i/$REPEAT...\e[0m"
    ./run_test.sh $i "$COVERAGE_ROOT_DIR" "$LOG_DIR" "$RESULTS_FILE" "$TESTS_DIR"
done

# Collect and merge coverage
echo -e "\e[31;1m>> Collecting all coverage files...\e[0m"

COVERAGE_FILES=""
for test_dir in "$TESTS_DIR"/*; do
	COVERAGE_FILES+=" $test_dir/coverage/coverage.vdb"
done


if [ -z "$COVERAGE_FILES" ]; then
    echo -e "\e[31;1m>> No coverage files found. Aborting.\e[0m"
    exit 1
fi

echo -e "\e[31;1m>> Merging coverage results...\e[0m"
urg -format both -dbname "$FINAL_COVERAGE_DB" -dir $COVERAGE_FILES -report "$REGRESSION_DIR/coverage_report" || {
    echo -e "\e[31;1m>> Coverage merge failed.\e[0m"
    exit 1
}

echo -e "\e[31;1m>> Coverage merge completed. Coverage report available at $REGRESSION_DIR/coverage_report\e[0m"

echo -e "\e[31;1m>> Regression completed successfully.\e[0m"
