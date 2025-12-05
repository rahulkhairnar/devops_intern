#!/bin/bash

# --- 1. Define Variables ---
PROJECT_DIR="devops-intern-final1"
MONITORING_DIR="$PROJECT_DIR/monitoring"
LOKI_SETUP_FILE="$MONITORING_DIR/loki_setup.txt"
DOCKER_COMPOSE_FILE="$MONITORING_DIR/docker-compose.yml"
PROMTRAIL_CONFIG_FILE="$MONITORING_DIR/promtail-config.yml"
COMMIT_MESSAGE="Feature: Add Loki monitoring documentation and setup files"

echo "--- Starting Loki Monitoring Setup FIX ---"

# --- 2. Clean Up and Setup Directories ---
echo "1. Cleaning up previous untracked directory and creating monitoring directory..."
# Remove the old untracked monitoring directory if it exists
rm -rf "$MONITORING_DIR"
mkdir -p "$MONITORING_DIR"

# --- 3. Create Promtail Configuration File (Same as before) ---
echo "2. Creating Promtail configuration file..."
cat << EOF > "$PROMTRAIL_CONFIG_FILE"
server:
  http_listen_port: 9080
  grpc_listen_port: 0
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://loki:3100/loki/api/v1/push
scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: codespace-logs
          __path__: /var/log/syslog
  - job_name: devops-hello-container
    static_configs:
      - targets:
          - localhost
        labels:
          job: devops-app
          environment: codespace
EOF

# --- 4. Create Docker Compose and Loki Config Files (Same as before) ---
echo "3. Creating Docker Compose and Loki config files..."
cat << EOF > "$DOCKER_COMPOSE_FILE"
version: "3.7"

networks:
  loki:

services:
  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - loki
    volumes:
      - ./loki-config.yaml:/etc/loki/local-config.yaml
  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    volumes:
      - ./promtail-config.yml:/etc/promtail/config.yml
      - /var/log:/var/log
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock
    command: -config.file=/etc/promtail/config.yml
    networks:
      - loki
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3000:3000"
    networks:
      - loki
    environment:
      - GF_AUTH_ANONYMOUS_ENABLED=true
      - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
EOF

cat << EOF > "$MONITORING_DIR/loki-config.yaml"
auth_enabled: false
server:
  http_listen_port: 3100
compactor:
  working_directory: /tmp/loki/compactor
ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
chunk_store:
  max_look_back_period: 0s
schema_config:
  configs:
    - from: 2020-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h
limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
EOF

# --- 5. Create the Loki Setup Documentation File (FIXED LOGCLI) ---
echo "4. Creating documentation file: $LOKI_SETUP_FILE (commands escaped)"
cat << EOF > "$LOKI_SETUP_FILE"
# Loki Monitoring Setup Documentation

This file documents the steps taken to configure a local monitoring stack using Docker Compose.

## 1. How Loki and Promtail were started

The entire stack (Loki, Promtail, Grafana) is defined in 'monitoring/docker-compose.yml'.

**Start Command:**
To run the services locally using Docker:
\`\`\`bash
cd $MONITORING_DIR
docker-compose up -d
\`\`\`

## 2. Command to view logs (Grafana Interface)

**Log Query Command Example (LogQL):**
To find all logs from our application container:
\`\`\`logql
{job="devops-app"}
\`\`\`

## 3. Alternative Verification Command (CLI)

If you have the Loki CLI (\`logcli\`) installed, you can query directly:

\`\`\`bash
# Query the local Loki instance
logcli query --addr=http://localhost:3100 '{job="devops-app"}'
\`\`\`
EOF

# --- 6. Update README.md (FIXED REDIRECTION) ---
echo "5. Updating README.md with monitoring reference..."
cat << EOF >> "$README_FILE"

## 👁️ Monitoring (Loki, Promtail, Grafana)

The monitoring setup for container logs is defined in the \`$MONITORING_DIR/\` directory.

The stack uses:
* **Loki:** Centralized log aggregation.
* **Promtail:** Log shipper configured to scrape container logs.
* **Grafana:** Visualization interface.

**See the documentation for startup instructions and LogQL queries:**
* [\`monitoring/loki_setup.txt\`](monitoring/loki_setup.txt)

EOF

# --- 7. Git Operations (Stage, Commit, Push) ---
echo "6. Staging files and committing..."

# Stage the entire project directory to catch the new monitoring folder and updated README
# This also stages the deletions of the old helper scripts you mentioned.
git add . 

git commit -m "$COMMIT_MESSAGE"

echo "7. Pushing changes to GitHub..."
git push

echo "--- Setup complete and files pushed to GitHub. ---"
