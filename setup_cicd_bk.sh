#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
WORKFLOWS_DIR="$PROJECT_DIR/.github/workflows"
WORKFLOW_FILE="$WORKFLOWS_DIR/ci.yml"
README_FILE="$PROJECT_DIR/README.md"
REPO_NAME=$(basename $(git rev-parse --show-toplevel)) # Gets the current repository name
COMMIT_MESSAGE="Feature: Add GitHub Actions CI workflow (ci.yml) and status badge"

echo "--- Starting CI Workflow Setup ---"

# --- 2. Check and Navigate ---
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory '$PROJECT_DIR' not found. Exiting."
    exit 1
fi
cd $PROJECT_DIR

# --- 3. Create the workflow directory ---
echo "1. Creating workflow directory: $WORKFLOWS_DIR"
mkdir -p "$WORKFLOWS_DIR"

# --- 4. Write the CI Workflow file (ci.yml) ---
echo "2. Creating workflow file: $WORKFLOW_FILE"
cat << EOF > "$WORKFLOW_FILE"
name: Python Hello CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout Repository
      uses: actions/checkout@v4
      
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.x'
        
    - name: Execute hello.py
      # The script is expected to be in the root of the checked-out directory (devops-intern-final1)
      run: |
        echo "Running the simple Python script..."
        python hello.py
EOF

# --- 5. Update README.md with the Status Badge ---
echo "3. Updating README.md with the CI status badge..."

# Find the repository owner/username (CodeSpaces often use the current user's details)
# Note: Since the exact username isn't known, we use a placeholder or assume a variable from the environment.
# In a Codespace, the default remote is usually configured correctly.
# The badge URL format is: https://github.com/<OWNER>/<REPO>/actions/workflows/<WORKFLOW_FILENAME>/badge.svg
BADGE_URL="https://github.com/\${{ github.repository }}/actions/workflows/ci.yml/badge.svg"
BADGE_MARKDOWN="![CI Status]($BADGE_URL)"

# Insert the badge at the top of the README (before the first actual heading)
# We read the current content, prepend the badge, and rewrite the file.
README_CONTENT=$(cat $README_FILE)

# Remove the existing badge if it exists to prevent duplication
CLEAN_README=$(echo "$README_CONTENT" | sed '/^\[!\[CI Status\]/d')

# Prepend the badge to the clean content
echo "$BADGE_MARKDOWN" > "$README_FILE"
echo "" >> "$README_FILE"
echo "$CLEAN_README" >> "$README_FILE"

# --- 6. Git Operations (Stage, Commit, Push) ---
echo "4. Staging files and committing..."
# Stage all changes in .github and README.md
git add .github README.md

git commit -m "$COMMIT_MESSAGE"

echo "5. Pushing changes to GitHub..."
git push

echo "--- Setup complete and changes pushed to GitHub. ---"
