#!/bin/bash


# --- Environment Setup ---

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
readonly AWK_SCRIPT="$SCRIPT_DIR/parser_logic.awk"
readonly CONFIG_FILE="$SCRIPT_DIR/config.sh"
readonly TEST_SCRIPT="$SCRIPT_DIR/test_setup.sh"


# --- 2. Core Functions ---


#/*!
# @brief Executes the integration test suite.
#*/
_doc_rf_run_test_setup() {
    [[ -f "$TEST_SCRIPT" ]] || { echo -e "\nError: test_setup.sh missing" >&2; exit 1; }
    exec bash "$TEST_SCRIPT"
}

#/*!
# @brief Generates a Markdown-compatible anchor ID.
# @param input_string The raw header string to be normalized.
# */
_doc_rf_generate_anchor() {
    # Convert "File: test.sh" to "file-testsh"
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | tr ' ' '-'
}

#/*!
# @brief Extracts documentation blocks from a target script.
# @param file_path The path to the shell script being parsed.
# */
_doc_rf_extract_docs() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    local file_header="File: $filename"
    
    # Append file entry to Table of Contents buffer
    TOC_BUFFER+="\n* [**$filename**](#$(_doc_rf_generate_anchor "$file_header"))"

    # Append file header to the main content buffer
    {
        printf "\n## File: %s\n" "$filename"
        printf "*(Path: %s)*\n---\n\n" "$file_path"
    } >> "$TEMP_CONTENT"
    
    # Parse file using AWK and capture function names for the ToC
    while read -r func_name; do
        local func_slug=$(_doc_rf_generate_anchor "Function: $func_name")
        TOC_BUFFER+="\n    * [$func_name](#$func_slug)"
    done < <(awk -v OFILE="$TEMP_CONTENT" -f "$AWK_SCRIPT" "$file_path")
}

#/*!
# @brief Compiles a list of valid files to process based on exclusion rules.
# */
_doc_rf_list_valid_files() {
    local args=("${TARGET_DIRS[@]}")
    
    # Construct exclusion arguments
    for path in "${CONFIG_IGNORE_PATHS[@]}"; do
        args+=("-not" "-path" "*$path*")
    done
    
    # Construct inclusion criteria
    args+=("-type" "f" "-name" "*.sh")
    
    find "${args[@]}"
}


# --- 2. Main Pipeline ---


#/*!
# @brief Orchestrates the documentation generation pipeline.
# */
_doc_rf_process_pipeline() {
    TEMP_CONTENT=$(mktemp)
    TOC_BUFFER="## Table of Contents\n---"

    # Process all valid files
    while read -r file; do
        _doc_rf_extract_docs "$file"
    done < <(_doc_rf_list_valid_files)

    # Assemble final Markdown Document
    mkdir -p "$(dirname "$DOC_FILE")"
    {
        printf "%b\n\n" "$CONFIG_DOC_HEADER"
        printf "%b\n\n" "$TOC_BUFFER"
        printf "\n---\n"
        cat "$TEMP_CONTENT"
    } > "$DOC_FILE"

    rm "$TEMP_CONTENT"
}


# --- Initialization & Execution ---


# Load configuration defaults
if [[ -f "$CONFIG_FILE" ]]; then source "$CONFIG_FILE"; else exit 1; fi

# Maps loaded config values
DOC_FILE="$CONFIG_DOC_FILE" # OUTPUT PATH
TARGET_DIRS=("${CONFIG_TARGET_DIRS[@]}") # READING DIRS


# Parse command-line arguments
while getopts "o:d:ht" opt; do
    case ${opt} in
        o) DOC_FILE="$OPTARG" ;;
        d) read -r -a TARGET_DIRS <<< "$OPTARG" ;;
        t) _doc_rf_run_test_setup ;;
        h|*) 
            printf "Usage: %s [-o output] [-d \"dirs\"] [-t]\n" "$0"; 
            exit 0 ;;
    esac
done

# Start documentaion process
_doc_rf_process_pipeline

# Output result
echo -e "\n\nDocumentation generated at: $DOC_FILE"