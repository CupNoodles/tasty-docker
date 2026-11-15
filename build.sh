#!/bin/bash
set -e
cd "$(dirname "$0")"

# Docker would create the bind mount as root:root if it doesn't exist, which is
# annoying for local development. Create it here under your own user instead.
mkdir -p ./tastyigniter

# Build the image with your host UID/GID so bind-mounted files stay owned by you.
export UID GID="$(id -g)"

docker compose up --build -d "$@"
docker compose ps
