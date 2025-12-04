#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
SCRIPTS_DIR="$PROJECT_DIR/scripts"
SYSINFO_FILE="$SCRIPTS_DIR/sysinfo.sh"
COMMIT_MESSAGE="Feature: Add scripts/sysinfo.sh for system information"

echo "--- Starting System Info Script Setup ---"

# --- 2. Check if the project directory exists ---
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory '$PROJECT_DIR' not found. Please ensure it exists."
    exit 1
fi

# --- 3. Create the scripts directory ---
echo "1. Creating directory: $SCRIPTS_DIR"
mkdir -p "$SCRIPTS_DIR"

# --- 4. Write the sysinfo.sh file ---
echo "2. Creating shell script: $SYSINFO_FILE"
cat << EOF > "$SYSINFO_FILE"
#!/bin/bash
# Script to display essential system information

echo "=============================="
echo "    System Information Report"
echo "=============================="

# Current User
echo "1. Current User:"
whoami
echo

# Current Date
echo "2. Current Date and Time:"
date
echo

# Disk Usage
echo "3. Disk Usage (Human-readable):"
df -h
echo "=============================="
EOF

# --- 5. Make the script executable ---
echo "3. Making $SYSINFO_FILE executable..."
chmod +x "$SYSINFO_FILE"

# --- 6. Git Operations (Stage, Commit, Push) ---
echo "4. Staging new files and committing..."
cd $PROJECT_DIR
git add scripts/

# Using the --amend flag here to add to the previous commit if it was very recent,
# but for a new feature, a new commit is better:
git commit -m "$COMMIT_MESSAGE"

echo "5. Pushing changes to GitHub..."
# Since we are in a Codespace, 'git push' is automatically authenticated.
git push

echo "✅ Setup complete and changes pushed to GitHub."
echo "--------------------------------------------------------"
echo "Next, run the script to see the system information output."
echo "--------------------------------------------------------"
