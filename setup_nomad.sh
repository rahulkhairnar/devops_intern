#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
NOMAD_DIR="$PROJECT_DIR/nomad"
NOMAD_FILE="$NOMAD_DIR/hello.nomad"
README_FILE="README.md"
COMMIT_MESSAGE="Feature: Add Nomad job file (nomad/hello.nomad) for orchestration"

echo "--- Starting Nomad Job Setup ---"

# --- 2. Check and Setup Directories ---
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory '$PROJECT_DIR' not found. Exiting."
    exit 1
fi

echo "1. Creating Nomad configuration directory: $NOMAD_DIR"
mkdir -p "$NOMAD_DIR"

# --- 3. Write the hello.nomad Job File ---
echo "2. Creating hello.nomad job file..."

# Note: The Docker image used here assumes the successful push from the final CD step,
# using the 'latest' tag for simplicity in this file.
REPO_OWNER=$(echo $GITHUB_REPOSITORY | cut -d '/' -f 1)
GHCR_IMAGE="ghcr.io/$GITHUB_REPOSITORY/devops-hello:latest"

cat << EOF > "$NOMAD_FILE"
job "hello-devops" {
  # The job type defines how the scheduler places the tasks.
  # 'service' is ideal for long-running processes.
  type = "service"

  # Minimal CPU and memory allocation
  datacenters = ["dc1"]
  
  group "greetings" {
    count = 1
    
    # Define minimal resources for the task
    task "hello-task" {
      driver = "docker"

      # Allocate minimal CPU (100 MHz) and memory (64 MB)
      resources {
        cpu    = 100 
        memory = 64
      }

      config {
        # CRITICAL: Use the Docker image built and pushed by the CD pipeline
        image = "$GHCR_IMAGE"
        
        # The image will automatically run the command defined in the Dockerfile (python hello.py)
        # We don't need a command here unless we want to override the Dockerfile CMD.
      }
      
      # Define a simple service block as requested
      service {
        name = "hello-service"
        tags = ["devops", "greetings"]
        # Since this script doesn't expose a port, the service block is minimal.
      }
    }
  }
}
EOF


# --- 4. Update README.md with Nomad Instructions ---
echo "3. Updating README.md with Nomad instructions..."

# Append the new section to README.md
cat << EOF >> "$README_FILE"

## 🟢 Container Orchestration (Nomad)

This section demonstrates how to deploy the Docker image using HashiCorp Nomad, a simple and flexible scheduler.

### Requirements
You must have a running Nomad agent cluster configured to use the 'docker' driver, and you must be logged into the GitHub Container Registry (GHCR) from the Nomad client machine.

### Deployment Instructions

1.  **Run the Job:** Deploy the job to the Nomad cluster.
    \`\`\`bash
    nomad job run $NOMAD_DIR/hello.nomad
    \`\`\`

2.  **View Status:** Check the status of the deployed task.
    \`\`\`bash
    nomad status hello-devops
    \`\`\`

3.  **View Logs:** Check the container output (which should show "Hello, DevOps!").
    \`\`\`bash
    nomad logs hello-devops
    \`\`\`

EOF

# --- 5. Git Operations (Stage, Commit, Push) ---
echo "4. Staging files and committing..."
# Stage the new nomad directory and the updated README
git add "$NOMAD_DIR" "$README_FILE"

git commit -m "$COMMIT_MESSAGE"

echo "5. Pushing changes to GitHub..."
git push

echo "--- Setup complete and changes pushed to GitHub. ---"
