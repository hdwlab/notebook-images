#!/usr/bin/env bash
set -Eeo pipefail

# Start SSH Server
${ENABLE_SSH_SERVER} && /usr/sbin/sshd

/init gosu ${NB_USER} "$@"