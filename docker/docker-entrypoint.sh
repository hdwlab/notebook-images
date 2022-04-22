#!/usr/bin/env bash
set -Eeo pipefail

# Start SSH Server
ENABLE_SSH_SERVER=true
if ${ENABLE_SSH_SERVER}; then
  [[ ! -d /run/sshd ]] && mkdir /run/sshd
  /usr/sbin/sshd
fi

/init gosu ${NB_USER} /docker-entrypoint-internal.sh "$@"