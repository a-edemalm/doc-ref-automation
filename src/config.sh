#!/bin/bash

# // The default output path for the generated markdown file.
# // You can change this to "README.md" or "wiki/API.md" depending on the project.
CONFIG_DOC_FILE="docs/API_reference.md"

# // The default directories the tool should scan. 
# // Using a Bash array here keeps it clean and easy to loop through later.
CONFIG_TARGET_DIRS=(".")

CONFIG_IGNORE_PATHS=(
    "doc-ref-automation"
    "test_lab"
    ".git"
    "node_modules"
    "bin"
)

# // The markdown header injected at the top of the generated file.
CONFIG_DOC_HEADER="# Project API Reference\n---"