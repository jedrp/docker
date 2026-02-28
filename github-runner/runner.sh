#!/bin/bash
set -e

sudo chmod 666 /var/run/docker.sock 2>/dev/null || true

cd /home/runner/actions-runner

echo ${GITHUB_REPO_URL}
echo ${GITHUB_RUNNER_TOKEN}
./config.sh remove --token ${GITHUB_RUNNER_TOKEN} || true
./config.sh --url ${GITHUB_REPO_URL} --token ${GITHUB_RUNNER_TOKEN} --labels ${RUNNER_LABELS:-self-hosted,Linux,X64} || true
# Run the runner directly in foreground (not as a service)
./run.sh