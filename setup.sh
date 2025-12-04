#!/bin/bash

# --- 1. Define Variables ---
# IMPORTANT: Replace [Your Name] and [Current Date] with your actual information
PROJECT_DIR="devops-intern-final1"
YOUR_NAME="[Shalini K]"
CURRENT_DATE="[04-12-2025]"
COMMIT_MESSAGE="Initial commit: Add README and hello.sh script"

echo "Starting project setup for $PROJECT_DIR..."

# --- 2. Create and Navigate Directory ---
mkdir $PROJECT_DIR
cd $PROJECT_DIR

# --- 3. Create README.md ---
echo "Creating README.md..."
cat << EOF > README.md
# 🛠️ DevOps Intern Final Project
## Name: $YOUR_NAME
## Date: $CURRENT_DATE
## Project Description: This project serves as the final submission for the DevOps Internship program, showcasing foundational Git and scripting skills.
EOF

# --- 4. Create hello.sh script ---
echo "Creating hello.sh..."
cat << EOF > hello.sh
#!/bin/bash
# A simple script to print a greeting
echo "Hello, DevOps!"
EOF

# --- 5. Make the script executable ---
echo "Making hello.sh executable..."
chmod +x hello.sh

# --- 6. Initialize Git (Usually already done in Codespace, but harmless to repeat) ---
# If you are already inside the main repository's codespace, you might skip git init
# and only use the steps below. If you created this folder outside of the main repo
# directory, you'll need to handle the git setup.
# Assuming you are running this in the root of your existing Codespace repository:

# --- 7. Stage Files ---
echo "Staging changes..."
git add README.md hello.sh

# --- 8. Commit Changes ---
echo "Committing changes..."
git commit -m "$COMMIT_MESSAGE"

# --- 9. Push Changes to GitHub ---
# Because you are in a Codespace, your remote 'origin' is already set up to point
# back to your GitHub repository, and your authentication is handled automatically.
echo "Pushing changes to GitHub..."
git push

echo "✅ Script finished successfully. Changes are now pushed to your GitHub repository."
