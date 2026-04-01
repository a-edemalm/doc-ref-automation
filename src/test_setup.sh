#!/bin/bash


# --- Enviorement Setup ---


readonly SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
readonly SAMPLE_LIB="$SETUP_DIR/test_scenarios.sh"
readonly TEST_LAB="$SETUP_DIR/../test_lab"
readonly MAIN_TOOL="$SETUP_DIR/main.sh"


# --- Helper Methods --- 

#/*!
# @brief Validates and sources the required test sample library.
# */
_bootstrap_test_assets() {
    if [[ -f "$SAMPLE_LIB" ]]; then
        source "$SAMPLE_LIB"
    else
        echo "Error: Test samples library missing at $SAMPLE_LIB" >&2
        return 1
    fi
}

#/*!
# @brief Cleans and recreates the isolated test directory (Test Lab).
# */
_prepare_test_lab() {
    rm -rf "$TEST_LAB" && mkdir -p "$TEST_LAB"
    _generate_test_samples "$TEST_LAB"
}

#/*!
# @brief Triggers the parser against the generated test fixtures.
# */
_execute_test_run() {
    local output_file="$TEST_LAB/test_output.md"
    bash "$MAIN_TOOL" -o "$output_file" -d "$TEST_LAB"
}

#/*!
# @brief Confirms the existence of the generated output and reports status.
# */
_verify_test_output() {
    local target="$TEST_LAB/test_output.md"
    if [[ -f "$target" ]]; then
        echo "Success: Validation report generated at $target"
    else
        echo "Failure: Parser failed to produce output." >&2
        return 1
    fi
}


#--- Orchestration ---


#/*!
# @brief High-level orchestrator for the testing lifecycle.
# */
_run_test_configuration() {
    echo "--- Phase 1: Bootstrapping Assets ---"
    _bootstrap_test_assets || exit 1

    echo "--- Phase 2: Preparing Environment ---"
    _prepare_test_lab

    echo "--- Phase 3: Executing Parser ---"
    _execute_test_run

    echo "--- Phase 4: Verifying Results ---"
    _verify_test_output || exit 1
}

_run_test_configuration