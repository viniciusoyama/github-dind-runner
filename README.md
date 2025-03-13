# Setup

## Sysbox Installation
Install https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#installing-sysbox

Confirm that docker has access to the runtime:

`cat /etc/docker/daemon.json`

https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md#docker-runtime-configuration

## Runner setup

Setup your .env:
`cp .env.example .env`

Build:
`docker compose build`

Run:
`docker compose up -d`

# github-runner-dockerfile
Dockerfile for the creation of a GitHub Actions runner image to be deployed dynamically. [Find the full explanation and tutorial here](https://baccini-al.medium.com/creating-a-dockerfile-for-dynamically-creating-github-actions-self-hosted-runners-5994cc08b9fb).

When running the docker image, or when executing docker compose, environment variables for repo-owner/repo-name and github-token must be included.

Credit to [testdriven.io](https://testdriven.io/blog/github-actions-docker/) for the original start.sh script, which I slightly modified to make it work with a regular repository rather than with an enterprise.

Whene generating your GitHub PAT you will need to include `repo`, `workflow`, and `admin:org` permissions.
