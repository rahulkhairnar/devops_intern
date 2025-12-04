[![CI Status](https://github.com/workspaces/devops_intern/actions/workflows/ci.yml/badge.svg)](https://github.com/workspaces/devops_intern/actions/workflows/ci.yml)


# 🛠️ DevOps Intern Final Project
## Name: [Shalini K]
## Date: [04-12-2025]
## Project Description: This project serves as the final submission for the DevOps Internship program, showcasing foundational Git and scripting skills.

## 🐳 Containerization (Docker)

This project has been containerized using a simple Dockerfile.

### Build the Image
The image is built using the local Dockerfile and tagged as `devops-hello`.

```bash
docker build -t devops-hello .
```

### Run the Container
The container executes `python hello.py` on startup and terminates immediately after. The `--rm` flag automatically cleans up the container after it exits.

```bash
docker run --rm devops-hello
```
