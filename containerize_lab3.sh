#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
IMAGE_NAME="devops-hello"
COMMIT_MESSAGE="Feature: Add Dockerfile and containerization instructions to README.md"

echo "--- Starting Docker Containerization Setup ---"

# --- 2. Check and Navigate ---
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory '$PROJECT_DIR' not found. Exiting."
    exit 1
fi
cd $PROJECT_DIR

# --- 3. Ensure hello.py exists (Needed for the Dockerfile) ---
if [ ! -f "hello.py" ]; then
    echo "Creating missing hello.py (needed for containerization)..."
    cat << EOF > hello.py
print("Hello, DevOps!")
EOF
fi

# --- 4. Create the Dockerfile ---
echo "1. Creating Dockerfile..."
cat << EOF > Dockerfile
# Use a lightweight official Python image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python script into the container
COPY hello.py .

# Command to run the Python script when the container starts
CMD ["python", "hello.py"]
EOF

# --- 5. Build the Docker Image ---
echo "2. Building Docker image: $IMAGE_NAME..."
# The '.' at the end specifies that the build context is the current directory.
docker build -t $IMAGE_NAME .
[Image of Docker containerization workflow]

# --- 6. Run the Docker Container and Capture Output ---
echo "3. Running the Docker container and capturing output..."
CONTAINER_OUTPUT=$(docker run --rm $IMAGE_NAME)
echo "--------------------------------------------------------"
echo "✅ CONTAINER OUTPUT: $CONTAINER_OUTPUT"
echo "--------------------------------------------------------"

# --- 7. Update README.md with instructions ---
echo "4. Updating README.md with Docker instructions..."
cat << EOF >> README.md

## 🐳 Containerization (Docker)

This project has been containerized using a simple Dockerfile.

### Build the Image
The image is built using the local Dockerfile and tagged as \`devops-hello\`.

\`\`\`bash
docker build -t devops-hello .
\`\`\`

### Run the Container
The container executes \`python hello.py\` on startup and terminates immediately after. The \`--rm\` flag automatically cleans up the container after it exits.

\`\`\`bash
docker run --rm devops-hello
\`\`\`
EOF

# --- 8. Git Operations (Stage, Commit, Push) ---
echo "5. Staging files (Dockerfile, hello.py, README.md) and committing..."
git add Dockerfile hello.py README.md

git commit -m "$COMMIT_MESSAGE"

echo "6. Pushing changes to GitHub..."
git push

echo "--- Setup complete and changes pushed to GitHub. ---"
