#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(readlink -f "$(dirname "$0")")
WORKSPACE_ROOT="$SCRIPT_DIR/../"

# https://github.com/docker/buildx/issues/484
export BUILDKIT_STEP_LOG_MAX_SIZE=10000000

${PUSH_IMAGE:-false} && loadOrPush="--push" || loadOrPush="--load"

set -x
docker buildx bake ${loadOrPush} --progress=plain -f "$SCRIPT_DIR/docker-bake.hcl" \
    --set "*.context=$WORKSPACE_ROOT" \
    --set "*.ssh=default"