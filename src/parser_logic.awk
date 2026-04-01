#!/usr/bin/awk -f

#/*!
# @brief Strip leading comment markers, asterisks, and whitespace from doc lines.
# @param line The raw string read from the source file.
# @return A sanitised string containing only the documentation text.
#*/
function clean_metadata(line) {
    gsub(/^[[:space:]]*#/, "", line);

    gsub(/^[[:space:]]*\*/, "", line);

    gsub(/^[[:space:]]*\//, "", line);

    return line;
}    

#/*!
# @brief Transform @tags into bold Markdown and append to the output file.
# @param func_name The name of the function being documented.
# @param doc_buffer The accumulated documentation strings.
# @param output_file The path to the final Markdown document.
#*/
function format_and_save(func_name, doc_buffer, output_file) {
    if (doc_buffer == "") return;

    # Print function header
    print "### Function: `" func_name "`\n" >> output_file

    # Format and print the @tags
    gsub(/@brief /, " **Brief:** ", doc_buffer);
    gsub(/@param /, "\n  **Parameter:** ", doc_buffer);
    gsub(/@return /, "\n  **Returns:** ", doc_buffer);

    print doc_buffer "\n" >> output_file;

}   

#/*!
# @brief Initialise state variables for the collection pipeline.
#*/
BEGIN {
    false = 0;
    true = 1;

    is_collecting = false;
    doc_buffer = "";
}

#/*!
# @brief Accumulate and sanitise lines while inside a valid docblock.
#*/
is_collecting {
   if ($0 !~ /^[[:space:]]*#/) {
        is_collecting = 0;
    } else {
        line = clean_metadata($0);
        
        # Only append if the line isn't just whitespace
        if (line ~ /[^[:space:]]/) {
            doc_buffer = doc_buffer line "\n";
        }
        next;
    }
}

#/*!
# @brief Enable collection mode upon detecting the specific docblock marker.
#*/
/^#\/\*!/ { 
    is_collecting = true; 
    doc_buffer = ""; 
    next 
}

#/*!
# @brief Detect function signatures and trigger the documentation export.
#*/
/^[[:space:]]*(function)?[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\(\).*\{/ {
    
    # Extract name by removing the trailing ()
    match($0, /[a-zA-Z_][a-zA-Z0-9_]*\(\)/);
    func_name = substr($0, RSTART, RLENGTH - 2);

    # 1. Write the full documentation to the output file (OFILE)
    format_and_save(func_name, doc_buffer, OFILE);

    # 2. Print ONLY the function name to stdout so Bash can capture it for the ToC
    print func_name;

    doc_buffer = "";
    is_collecting = 0;
}