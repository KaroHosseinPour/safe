#!/usr/bin/env bash
# Starts the PentAGI stack once the Docker daemon is up.
set -euo pipefail
cd "$(dirname "$0")/../pentagi"

for _ in $(seq 1 60); do docker info >/dev/null 2>&1 && break; sleep 2; done
docker compose up -d
docker compose ps
echo "PentAGI روشن شد. تب Ports را باز کنید و پورت 8443 را در مرورگر باز کنید."
