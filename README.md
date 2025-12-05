[![CI Status](https://github.com/${{ github.repository }}/actions/workflows/ci.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/ci.yml)




# 🛠️ DevOps Intern Final Project

... (existing content preserved) ...

## 🐳 Continuous Delivery (CD)

This project is automatically built, tested, and published to the GitHub Container Registry (GHCR).

### Image Location
The image is available at: `ghcr.io/${{ github.repository }}/devops-hello:latest`

### Pull and Run
You can pull the latest image and run the container using your GitHub credentials:

```bash
# 1. Log in to GHCR (requires a Personal Access Token with read:packages scope)
echo $GH_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# 2. Pull the latest image
docker pull ghcr.io/${{ github.repository }}/devops-hello:latest

# 3. Run the container
docker run --rm ghcr.io/${{ github.repository }}/devops-hello:latest
```

## 🟢 Container Orchestration (Nomad)

This section demonstrates how to deploy the Docker image using HashiCorp Nomad, a simple and flexible scheduler.

### Requirements
You must have a running Nomad agent cluster configured to use the 'docker' driver, and you must be logged into the GitHub Container Registry (GHCR) from the Nomad client machine.

### Deployment Instructions

1.  **Run the Job:** Deploy the job to the Nomad cluster.
    ```bash
    nomad job run devops-intern-final1/nomad/hello.nomad
    ```

2.  **View Status:** Check the status of the deployed task.
    ```bash
    nomad status hello-devops
    ```

3.  **View Logs:** Check the container output (which should show "Hello, DevOps!").
    ```bash
    nomad logs hello-devops
    ```

