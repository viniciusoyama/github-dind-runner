#!/bin/bash

# Phoenix Pattern
# If the host machine restarts
# The docker start can fail on the first try because
# sysbox-runc may not be initialized yet
# So we just keep running until it works
echo "Waiting for Docker to start..."
while ! docker info >/dev/null 2>&1; do
  sudo service docker start
  sleep 3
done

if [ -n "${GITHUB_REPOSITORY}" ]; then
  auth_url="https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPOSITORY}/actions/runners/registration-token"
  registration_url="https://github.com/${GITHUB_OWNER}/${GITHUB_REPOSITORY}"
else
  auth_url="https://api.github.com/orgs/${GITHUB_OWNER}/actions/runners/registration-token"
  registration_url="https://github.com/${GITHUB_OWNER}"
fi

echo "Fetching registration token..."
REG_TOKEN=$(curl -X POST -H "Authorization: token ${TOKEN}" -H "Accept: application/vnd.github+json" ${auth_url} | jq .token --raw-output)

cd /home/runner

echo "Configuring runner..."
./config.sh --url ${registration_url} --token ${REG_TOKEN} --labels "${RUNNER_LABELS}"

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh "$*"