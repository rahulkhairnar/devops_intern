# Module 01: Git, Scripting, and Docker Basics

This module contains the foundational scripts and configuration demonstrating basic Linux scripting and containerization skills (Assignments 1, 2, 3).

## Assignment 1: Git & GitHub Setup
- **Goal:** Initialize the project and commit a sample script.
- **Verification:** The existence of `hello.py` and the initial commit message in repository history.

## Assignment 2: Linux & Scripting Basics
- **Goal:** Write a shell script to gather system information.
- **File:** `scripts/sysinfo.sh`
- **Contents:** Prints `whoami`, `date`, and `df -h`.
- **Verification:**
  ```bash
  ./scripts/sysinfo.sh
  ```

## Assignment 3: Docker Basics
- **Goal:** Containerize the Python greeting script.
- **File:** `Dockerfile`
- **Container Command:** Runs `python hello.py` on startup.
- **Verification:**
  ```bash
  docker build -t devops-hello .
  docker run --rm devops-hello
  # Expected Output: Hello, DevOps!
  ```
