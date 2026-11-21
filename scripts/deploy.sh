#!/usr/bin/env bash
set -euo pipefail

REPO=/srv/ad/deploy
COMMIT="${1:?Commit SHA required}"

exec 9>/run/lock/deploy.lock
flock -n 9 || {
    echo "Deployment already running"
    exit 1
}

cd "$REPO"

git fetch origin
git checkout --detach "$COMMIT"

IMAGE_TAG="$COMMIT" docker compose build
IMAGE_TAG="$COMMIT" docker compose up -d

echo "Deployed $COMMIT"
