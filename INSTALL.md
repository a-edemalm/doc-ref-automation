# Installation

Follow these steps to install and set up `doc-ref-automation` on your local machine:

---

## 1. Clone the Repository

```bash
git clone https://github.com/your-username/doc-ref-automation.git
cd doc-ref-automation
```

---

## 2. Proper Script Placement

For the automation to function correctly, the execution script must be positioned at the root of your project.

**Requirement:**
- The script must be placed inside the project folder but **outside** the `src` directory.

**Why:**
- This allows the script to maintain a global view of both your source code and your documentation folders.

---

## 3. Configure File Exclusions

Before running the tool, define which files the script should ignore. This prevents unnecessary processing.

**Steps:**
- Locate the configuration section (e.g., `config.json` or inside the script).
- Add common exclusions such as:
  - `node_modules/`
  - `.git/`
  - `dist/`

---

## 4. Make the Script Executable

Ensure the main script has execution permissions:

```bash
chmod +x src/main.sh
```

---

## 5. Verify Installation

Run the built-in test suite to confirm everything is working correctly:

```bash
./src/test_setup.sh
```

**or**

```bash
./doc-ref-automation/src/test_setup.sh
```