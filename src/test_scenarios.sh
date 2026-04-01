#!/bin/bash

#/*!
# @brief Generates standardized test files for parser validation.
# @param test_dir The target directory where sample files will be created.
# */
_generate_test_samples() {
    local test_dir="$1"

    # Scenario 1: Standard function with compact docblock
    cat << 'EOF' > "$test_dir/test_code.sh"
#/*!
# @brief Integration test function.
# @param val A test value.
#*/
function test_file_1() {
    echo "$1"
}

EOF

    # Scenario 2: Multiple functions, varying white space, and partial tags
    cat << 'EOF' > "$test_dir/test_code2.sh"
#/*!
# @brief Integration test function.
# @param val A test value.
#*/

function test_spacious_file_2() {
    echo "$1"
}

echo "Doing something else..."

#/*!
# @brief Integration test function.
# */
function test_space_file_2() {
    echo "$1"
}

#/*!
# @param val A test value.
#*/
function test_removed_brief_file2() {
    echo "$1"
}

#/*!
# @brief Integration test function.
#*/
function test_removed_param_file2() {
    echo "$1"
}

EOF
}