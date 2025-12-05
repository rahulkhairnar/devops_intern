# Module 02: CI/CD and Orchestration (Nomad)

This module contains the automated testing framework and the configuration for deploying the containerized application using Nomad (Assignments 4, 5).

## Assignment 4: CI/CD with GitHub Actions
- **Goal:** Automate testing and deployment on every push.
- **Workflow File:** `../.github/workflows/ci.yml`
- **Functionality:**
    1. Checkout code.
    2. Run **Unit Test** (`test_hello.py`).
    3. If tests pass, **Build** the Docker image from `../01-Basics/Dockerfile`.
    4. **Push** the image to GitHub Container Registry (GHCR).
- **Verification:** Green checkmark on the GitHub Actions tab.

## Assignment 5: Job Deployment with Nomad
- **Goal:** Define a job for container orchestration.
- **File:** `nomad/hello.nomad`
- **Configuration:** Uses `type = "service"`, `driver = "docker"`, and minimal resource allocation (CPU 100, Memory 64).
- **Verification:**
  ```bash
  # Assuming Nomad cluster is available:
  nomad job run nomad/hello.nomad
  nomad logs -job hello-devops
  # Expected Output: Hello, DevOps!
  ```
