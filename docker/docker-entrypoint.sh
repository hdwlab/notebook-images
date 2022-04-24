#!/usr/bin/env bash
set -Eeo pipefail

if [[ $# -eq 0 ]]; then
    /docker-entrypoint-internal.sh /init
else
    /docker-entrypoint-internal.sh /init gosu ${NB_USER} "$@"
fi
