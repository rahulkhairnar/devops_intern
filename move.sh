#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
COMMIT_MESSAGE="Fix: Corrected CI workflow location to repository root"

echo "--- Starting CI Workflow Correction Script ---"

# --- 2. Check and Execute Move (CRITICAL STEP) ---
if [ -d "$PROJECT_DIR/.github" ]; then
    echo "1. Moving workflow directory from $PROJECT_DIR/.github to .github"

    # Move the .github directory up one level to the repository root
    mv "$PROJECT_DIR/.github" .
else
    echo "Error: Directory $PROJECT_DIR/.github not found. Please verify the project structure."
    exit 1
fi

# --- 3. Git Operations (Stage, Commit, Push) ---
echo "2. Staging all changes (move/delete) and committing..."
# The 'git add .' stages all modifications, moves, and deletions.
git add .
git commit -m "$COMMIT_MESSAGE"

echo "3. Pushing changes to GitHub (This push will trigger the workflow)..."
git push

echo "--- Correction complete and changes pushed to GitHub. ---"
echo "Please check the Actions tab again."
