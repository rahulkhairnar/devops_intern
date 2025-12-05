[![CI Status](https://github.com/${{ github.repository }}/actions/workflows/ci.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/ci.yml)

[![CI/CD Status](https://github.com/${{ github.repository }}/actions/workflows/ci.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/ci.yml)

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
