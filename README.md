# Doc Ref Automation

## About the Project
This tool was created to solve the messy problem of managing larger Bash scripts where functions often go undocumented. In complex projects, it can be incredibly difficult to find a good map or overview of all the available functions. 

`doc-ref-automation` solves this by automatically mapping out your project's scripts and generating a clear Table of Contents. It documents what each function needs, what it does, and what it returns, providing a clean, auto-generated overview in a single file.

## Features
* **Auto-Generated Table of Contents:** Creates a centralised, easy-to-read index of all scripts and their containing functions.
* **Function Mapping:** Scans project directories to map out Bash scripts and extract their functions.
* **Documentation Extraction:** Reads documentation blocks to clearly outline function requirements, parameters, and behaviors.
* **Single Output File:** Generates a single, consolidated Markdown API reference document for your entire project.
* **Smart Filtering:** Automatically ignores non-relevant directories (like `.git`, `node_modules`, `test_lab`, etc.) based on configurable rules.

## Work in Progress (Limitations)
* **GitHub Navigation:** Creating perfectly navigable anchor links for fast navigation directly within GitHub's markdown viewer is currently a work in progress.
* **Forgiving Comment Structures:** Making the parser completely forgiving in terms of how comments can be structured is a work in progress. It already handles varying whitespace and missing tags gracefully, but it relies on a specific base structure to identify blocks.

## Installation

For full installation instructions, see [INSTALL.md](./INSTALL.md).

## Usage
The main orchestration script handles the generation of your documentation.

You can run the script with the following command-line flags:

-o <output>: Specifies the output path for the generated markdown file (defaults to docs/API_reference.md if not set).

-d "<dirs>": Specifies the target directories the tool should scan for .sh files.

-t: Runs the built-in integration test suite and test setup.

-h: Displays the help and usage menu.

### Standard Comment Format
While the parser is somewhat flexible—allowing for empty spaces between lines and working perfectly fine if you omit tags like `@return` or `@param`—it is designed around this standard format for the best results:

```bash
#/*!
# @brief Brief description of what the function does.
# @param param_name Description of the parameter.
# @return Description of the return value.
#*/
function my_function() {
    # code...
}
```

## Examples

```bash
./doc-ref-automation/src/main.sh # in parent folder
```

```bash
./src/main.sh # inside tool-project
```

```bash
./src/main.sh -o "README_API.md" -d "src lib utils" # override file name and target directories
```

```bash
./src/main.sh -t # internal prefeatured tests
```
