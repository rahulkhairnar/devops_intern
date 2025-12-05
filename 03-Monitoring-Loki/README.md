# Module 03: Monitoring with Grafana Loki

This module contains the setup files and documentation for centralized logging using the Grafana Loki stack (Assignment 6).

## Assignment 6: Monitoring with Grafana Loki
- **Goal:** Configure a local stack of Loki (aggregator), Promtail (shipper), and Grafana (viewer).
- **Files:** All monitoring configuration files are in the `monitoring/` directory.
- **Verification:** The existence and documentation of the startup procedure.

### Required Documentation (`monitoring/loki_setup.txt`)
This file details the steps for local verification.

**How Loki was Started:**
The entire stack is started using Docker Compose from the `monitoring/` directory.
```bash
cd monitoring/
docker-compose up -d
```

**Command to View Logs (LogQL):**
Logs are viewed in the Grafana UI (http://localhost:3000) using the LogQL query:
```logql
{job="devops-app"}
```
