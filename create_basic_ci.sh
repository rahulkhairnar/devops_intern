#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
WORKFLOWS_DIR=".github/workflows"
WORKFLOW_FILE="$WORKFLOWS_DIR/ci.yml"
README_FILE="README.md"
COMMIT_MESSAGE="Fresh Start: Basic CI only, running hello.py"

echo "--- Starting Fresh Basic CI Setup ---"

# --- 2. Clean up Existing Workflows ---
echo "1. Deleting all previous workflow files in $WORKFLOWS_DIR..."
rm -rf "$WORKFLOWS_DIR"
mkdir -p "$WORKFLOWS_DIR"

# --- 3. Ensure Project Files Exist ---
echo "2. Ensuring project files are present..."
mkdir -p "$PROJECT_DIR" # Ensure project directory exists

# Ensure hello.py exists
if [ ! -f "$PROJECT_DIR/hello.py" ]; then
    cat << EOF > "$PROJECT_DIR/hello.py"
print("Hello, DevOps!")
EOF
fi

# --- 4. Write the Minimal CI Workflow file (ci.yml) ---
echo "3. Creating minimal ci.yml workflow file at repository root..."
cat << EOF > "$WORKFLOW_FILE"
name: Basic Hello Runner

on:
  push:
    branches: [ main ]

jobs:
  run_script:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout Repository
      uses: actions/checkout@v4
      
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.x'
        
    - name: Execute hello.py
      # The runner starts at the repository root, so we use the full path.
      run: |
        echo "Starting python script execution..."
        python $PROJECT_DIR/hello.py
EOF

# --- 5. Update README.md with the Status Badge ---
echo "4. Updating README.md with the CI status badge..."

# Define the badge URL (Uses GitHub's environment variables for accuracy)
BADGE_URL="https://github.com/\${{ github.repository }}/actions/workflows/ci.yml/badge.svg"
BADGE_MARKDOWN="[![CI Status]($BADGE_URL)](https://github.com/\${{ github.repository }}/actions/workflows/ci.yml)"

# Read the current README content
README_CONTENT=$(cat $README_FILE 2>/dev/null || echo "# DevOps Project")
# Remove old badges to prevent clutter
CLEAN_README=$(echo "$README_CONTENT" | sed '/^\[!\[CI Status\]/d' | sed '/^\[!\[CI\/CD Status\]/d')

# Prepend the badge to the top of the README
echo "$BADGE_MARKDOWN" > "$README_FILE"
echo "" >> "$README_FILE"
echo "$CLEAN_README" >> "$README_FILE"

# --- 6. Git Operations (Stage, Commit, Push) ---
echo "5. Staging files and committing..."
# Stage all relevant files: the new workflow, and the updated README
git add "$PROJECT_DIR/hello.py" "$WORKFLOW_FILE" "$README_FILE"

git commit -m "$COMMIT_MESSAGE"

echo "6. Pushing changes to GitHub to trigger the basic CI workflow..."
git push

echo "✅ Script finished. Check GitHub Actions for the run titled 'Basic Hello Runner'."
