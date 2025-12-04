#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
WORKFLOWS_DIR="$PROJECT_DIR/.github/workflows"
WORKFLOW_FILE="$WORKFLOWS_DIR/ci.yml"
README_FILE="$PROJECT_DIR/README.md"
COMMIT_MESSAGE="Fix: Ensure CI workflow file is created and badge is added"

echo "--- Starting CI Workflow Setup V2 ---"

# --- 2. Check and Navigate (CRITICAL STEP) ---
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory '$PROJECT_DIR' not found. Exiting."
    exit 1
fi

# We execute the rest of the script FROM the root of the project
cd $PROJECT_DIR

# --- 3. Create the workflow directory ---
echo "1. Creating workflow directory: .github/workflows"
mkdir -p .github/workflows

# --- 4. Write the CI Workflow file (ci.yml) ---
echo "2. Creating workflow file: .github/workflows/ci.yml"
cat << EOF > .github/workflows/ci.yml
name: Python Hello CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test_hello:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout Repository
      # This checks out the entire repository (devops-intern-final1)
      uses: actions/checkout@v4
      
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.x'
        
    - name: Execute hello.py
      # The file is expected to be in the root of the project directory
      run: |
        echo "Running the simple Python script from the CI pipeline..."
        python hello.py
EOF

# --- 5. Update README.md with the Status Badge ---
echo "3. Checking and updating README.md with the CI status badge..."

# Define the badge URL based on the file path
BADGE_MARKDOWN="[![CI Status](https://github.com/$(basename $(dirname $(git rev-parse --show-toplevel)))/$(basename $(git rev-parse --show-toplevel))/actions/workflows/ci.yml/badge.svg)](https://github.com/$(basename $(dirname $(git rev-parse --show-toplevel)))/$(basename $(git rev-parse --show-toplevel))/actions/workflows/ci.yml)"

# Clean existing badge lines and then prepend the new badge to README.md
README_CONTENT=$(cat README.md)
CLEAN_README=$(echo "$README_CONTENT" | sed '/^\[!\[CI Status\]/d')

# Prepend the badge to the clean content
echo "$BADGE_MARKDOWN" > "README.md"
echo "" >> "README.md"
echo "$CLEAN_README" >> "README.md"


# --- 6. Git Operations (Stage, Commit, Push) ---
echo "4. Staging files and committing..."
# Stage the new workflow folder and the updated README
git add .github/ README.md

git commit -m "$COMMIT_MESSAGE"

echo "5. Pushing changes to GitHub to trigger the workflow..."
# Since we are in a Codespace, 'git push' is automatically authenticated.
git push

echo "--- Setup complete and changes pushed to GitHub. ---"
