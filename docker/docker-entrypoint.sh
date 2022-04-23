#!/usr/bin/env bash
set -Eeo pipefail

# Start SSH Server
ENABLE_SSH_SERVER=true
if ${ENABLE_SSH_SERVER}; then
  [[ ! -d /run/sshd ]] && mkdir /run/sshd
  /usr/sbin/sshd
fi

# Enable docker
DOCKER_SOCKET=/var/run/docker.sock
if [[ -S ${DOCKER_SOCKET} ]]; then
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
    DOCKER_GROUP=$(getent group ${DOCKER_GID} | awk -F ":" '{ print $1 }' || echo "")
    if [[ ${DOCKER_GROUP} ]]; then
        addgroup ${NB_USER} ${DOCKER_GROUP}
    else
        addgroup --system --gid ${DOCKER_GID} docker
        usermod -aG docker ${NB_USER}
    fi
fi

if [[ $# -eq 0 ]]; then
    /docker-entrypoint-internal.sh /init
else
    /docker-entrypoint-internal.sh /init gosu ${NB_USER} "$@"
fi
