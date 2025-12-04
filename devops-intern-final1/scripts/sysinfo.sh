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
