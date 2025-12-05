#!/bin/bash

# --- 1. Define Variables and Paths ---
CURRENT_PROJECT_DIR="devops-intern-final1"
CI_WORKFLOW_FILE=".github/workflows/ci.yml"
MAIN_README_FILE="README.md"
COMMIT_MESSAGE="Refactor: Modularize project into 3 main folders with dedicated READMEs."

# New module directories
M1_DIR="01-Basics"
M2_DIR="02-CI-CD-Orchestration"
M3_DIR="03-Monitoring-Loki"

# --- 2. Create New Directories ---
echo "--- Starting Project Refactoring ---"

echo "1. Creating new modular directories: $M1_DIR, $M2_DIR, $M3_DIR"
mkdir -p "$M1_DIR/scripts" "$M2_DIR/nomad" "$M3_DIR/monitoring"

# --- 3. Move Files to New Modules ---
echo "2. Moving existing project files to new modules..."

# Module 1: Basics (Git, Scripting, Docker)
mv "$CURRENT_PROJECT_DIR/hello.py" "$M1_DIR/hello.py"
mv "$CURRENT_PROJECT_DIR/scripts/sysinfo.sh" "$M1_DIR/scripts/sysinfo.sh" 2>/dev/null
mv "$CURRENT_PROJECT_DIR/Dockerfile" "$M1_DIR/Dockerfile" 2>/dev/null

# Module 2: CI/CD and Orchestration (Nomad)
mv "$CURRENT_PROJECT_DIR/test_hello.py" "$M2_DIR/test_hello.py" 2>/dev/null
mv "$CURRENT_PROJECT_DIR/nomad/hello.nomad" "$M2_DIR/nomad/hello.nomad" 2>/dev/null

# Module 3: Monitoring
mv "$CURRENT_PROJECT_DIR/monitoring/"* "$M3_DIR/monitoring/" 2>/dev/null

# Remove the now empty original directory
rm -rf "$CURRENT_PROJECT_DIR"
[Image of modular project structure]

# --- 4. CRITICAL: Update CI Workflow Paths ---
echo "3. Updating CI workflow ($CI_WORKFLOW_FILE) to use new paths..."
if [ -f "$CI_WORKFLOW_FILE" ]; then
    sed -i 's|devops-intern-final1|01-Basics|g' "$CI_WORKFLOW_FILE"
    sed -i 's|01-Basics/test_hello.py|02-CI-CD-Orchestration/test_hello.py|g' "$CI_WORKFLOW_FILE"
    # Ensure Docker context is updated
    sed -i 's|context: ./01-Basics|context: ./${{ env.PROJECT_DIR }}|g' "$CI_WORKFLOW_FILE" 
    sed -i 's|PROJECT_DIR: devops-intern-final1|PROJECT_DIR: 01-Basics|g' "$CI_WORKFLOW_FILE"
    sed -i '/context: ./!b; N; /context: ./s|01-Basics|./01-Basics|' "$CI_WORKFLOW_FILE"
    
    # Simple fix for CI/CD paths (we must ensure the test file is found)
    # This is a highly defensive rewrite to ensure the two critical run commands work.
    
    # 1. Update test_hello path
    sed -i 's|python3 -m unittest 01-Basics/test_hello.py|python3 -m unittest 02-CI-CD-Orchestration/test_hello.py|g' "$CI_WORKFLOW_FILE"

    # 2. Update context for Docker build
    sed -i 's|context: ./01-Basics|context: ./01-Basics|g' "$CI_WORKFLOW_FILE"

fi


# --- 5. Create Modular READMEs (Assignment Documentation) ---

echo "4. Creating documentation READMEs for each module..."

# --- 5A. Module 1: Basics (Git, Scripting, Docker) ---
cat << EOF > "$M1_DIR/$MAIN_README_FILE"
# Module 01: Git, Scripting, and Docker Basics

This module contains the foundational scripts and configuration demonstrating basic Linux scripting and containerization skills (Assignments 1, 2, 3).

## Assignment 1: Git & GitHub Setup
- **Goal:** Initialize the project and commit a sample script.
- **Verification:** The existence of \`hello.py\` and the initial commit message in repository history.

## Assignment 2: Linux & Scripting Basics
- **Goal:** Write a shell script to gather system information.
- **File:** \`scripts/sysinfo.sh\`
- **Contents:** Prints \`whoami\`, \`date\`, and \`df -h\`.
- **Verification:**
  \`\`\`bash
  ./scripts/sysinfo.sh
  \`\`\`

## Assignment 3: Docker Basics
- **Goal:** Containerize the Python greeting script.
- **File:** \`Dockerfile\`
- **Container Command:** Runs \`python hello.py\` on startup.
- **Verification:**
  \`\`\`bash
  docker build -t devops-hello .
  docker run --rm devops-hello
  # Expected Output: Hello, DevOps!
  \`\`\`
EOF

# --- 5B. Module 2: CI/CD and Orchestration (Nomad) ---
cat << EOF > "$M2_DIR/$MAIN_README_FILE"
# Module 02: CI/CD and Orchestration (Nomad)

This module contains the automated testing framework and the configuration for deploying the containerized application using Nomad (Assignments 4, 5).

## Assignment 4: CI/CD with GitHub Actions
- **Goal:** Automate testing and deployment on every push.
- **Workflow File:** \`../.github/workflows/ci.yml\`
- **Functionality:**
    1. Checkout code.
    2. Run **Unit Test** (\`test_hello.py\`).
    3. If tests pass, **Build** the Docker image from \`../01-Basics/Dockerfile\`.
    4. **Push** the image to GitHub Container Registry (GHCR).
- **Verification:** Green checkmark on the GitHub Actions tab.

## Assignment 5: Job Deployment with Nomad
- **Goal:** Define a job for container orchestration.
- **File:** \`nomad/hello.nomad\`
- **Configuration:** Uses \`type = "service"\`, \`driver = "docker"\`, and minimal resource allocation (CPU 100, Memory 64).
- **Verification:**
  \`\`\`bash
  # Assuming Nomad cluster is available:
  nomad job run nomad/hello.nomad
  nomad logs -job hello-devops
  # Expected Output: Hello, DevOps!
  \`\`\`
EOF

# --- 5C. Module 3: Monitoring (Loki) ---
cat << EOF > "$M3_DIR/$MAIN_README_FILE"
# Module 03: Monitoring with Grafana Loki

This module contains the setup files and documentation for centralized logging using the Grafana Loki stack (Assignment 6).

## Assignment 6: Monitoring with Grafana Loki
- **Goal:** Configure a local stack of Loki (aggregator), Promtail (shipper), and Grafana (viewer).
- **Files:** All monitoring configuration files are in the \`monitoring/\` directory.
- **Verification:** The existence and documentation of the startup procedure.

### Required Documentation (\`monitoring/loki_setup.txt\`)
This file details the steps for local verification.

**How Loki was Started:**
The entire stack is started using Docker Compose from the \`monitoring/\` directory.
\`\`\`bash
cd monitoring/
docker-compose up -d
\`\`\`

**Command to View Logs (LogQL):**
Logs are viewed in the Grafana UI (http://localhost:3000) using the LogQL query:
\`\`\`logql
{job="devops-app"}
\`\`\`
EOF


# --- 6. Update Main README (Table of Contents) ---
echo "5. Updating main README.md as a Table of Contents..."

# Read the existing content and remove old instructions that are now in sub-READMEs
CURRENT_README_CONTENT=$(cat "$MAIN_README_FILE" 2>/dev/null || echo "# DevOps Final Project Portfolio")
CLEANED_CONTENT=$(echo "$CURRENT_README_CONTENT" | head -n 10 | grep -E '^(#|!)') # Keep badge and title

cat << EOF > "$MAIN_README_FILE"
$CLEANED_CONTENT

# DevOps Final Project Portfolio: Assignment Summary

This repository organizes the six DevOps internship assignments into three functional modules for clarity and modularity.

| Module | Description | Verification |
| :--- | :--- | :--- |
| [**01-Basics**](./01-Basics/README.md) | Git, Linux Scripting, and Docker Containerization. | Docker build/run commands. |
| [**02-CI-CD-Orchestration**](./02-CI-CD-Orchestration/README.md) | Automated Testing (CI), GitHub Actions Workflow, and Nomad Job Deployment. | **GitHub Actions Green Checkmark** |
| [**03-Monitoring-Loki**](./03-Monitoring-Loki/README.md) | Centralized Logging with Loki, Promtail, and Grafana. | \`loki_setup.txt\` documentation. |
EOF


# --- 7. Git Operations (Stage, Commit, Push) ---
echo "6. Staging all modified files (moves, new READMEs, CI fix)..."
git add .
git commit -m "$COMMIT_MESSAGE"

echo "7. Pushing changes to GitHub to finalize the structure..."
git push

echo "--- Refactoring complete. Check your repository for the new structure! ---"
