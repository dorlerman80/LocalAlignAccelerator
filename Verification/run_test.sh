#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 TEST_ITERATION COVERAGE_DIR LOG_DIR RESULTS_FILE TESTS_DIR"
    exit 1
fi

TEST_ITERATION=$1
COVERAGE_DIR=$2
LOG_DIR=$3
RESULTS_FILE=$4
TESTS_DIR=$5

# List of tests
TESTS=("base_test" "clk_test" "rst_test" "start_test" "letters_test" "clk_rst_test")

# Select a test from the list (for now, we'll use a fixed index or you can randomize)
TEST_INDEX=$((RANDOM % ${#TESTS[@]}))  # Random index for selection
TEST_NAME=${TESTS[$TEST_INDEX]}

# Create a directory for this test iteration under tests/
TEST_DIR="$TESTS_DIR/${TEST_NAME}_${TEST_ITERATION}_$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$TEST_DIR/coverage" "$TEST_DIR/logs"


SEED=$((RANDOM * RANDOM))

# Run test
make TESTNAME="$TEST_NAME" SEED="$SEED" CONFIG_PARAMS="$CONFIG_PARAMS" COV_DIR="$TEST_DIR/coverage" LOG_DIR="$TEST_DIR/logs"

# Check results
VCS_LOG="$TEST_DIR/logs/vcs.log"
if grep -q "UVM_ERROR :    0" "$VCS_LOG" && grep -q "UVM_FATAL :    0" "$VCS_LOG"; then
    TEST_RESULT="PASSED"
else
    TEST_RESULT="FAILED"
fi

# Log results in a formatted table
echo -e "------------------------|-----------|-------------|--------------------------------------------------|--------" >> "$RESULTS_FILE"
printf "%-23s | %-9s | %-11s | %-48s | %-6s\n" "$TEST_NAME" "$TEST_ITERATION" "$SEED" "add params" "$TEST_RESULT" >> "$RESULTS_FILE"
