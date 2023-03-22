#syntax=docker/dockerfile:1.4
FROM base_image as devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Common environemnt variables
ENV NB_USER jovyan
ENV NB_UID 1000
ENV NB_PREFIX /
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash

# Args - software versions
ARG S6_ARCH="amd64"
ARG S6_VERSION=v2.2.0.3

# Install useful linux packages
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt -yq update \
 && apt -yq install --no-install-recommends \
    apt-transport-https \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    gnupg2 \
    gosu \
    locales \
    lsb-release \
    software-properties-common \
    tzdata \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN add-apt-repository --yes --update ppa:ansible/ansible \
  && apt update \
  && DEBIAN_FRONTEND=noninteractive apt -yq install --no-install-recommends \
    ansible \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Set locale configs
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install s6 overlay
RUN export GNUPGHOME=/tmp/ \
 && curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer" -o /tmp/s6-overlay-${S6_VERSION}-installer \
 && curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer.sig" -o /tmp/s6-overlay-${S6_VERSION}-installer.sig \
 && gpg --keyserver keys.gnupg.net --keyserver pgp.surfnet.nl --recv-keys 6101B2783B2FD161 \
 && gpg -q --verify /tmp/s6-overlay-${S6_VERSION}-installer.sig /tmp/s6-overlay-${S6_VERSION}-installer \
 && chmod +x /tmp/s6-overlay-${S6_VERSION}-installer \
 && /tmp/s6-overlay-${S6_VERSION}-installer / \
 && rm /tmp/s6-overlay-${S6_VERSION}-installer.sig /tmp/s6-overlay-${S6_VERSION}-installer

# Create user and set required ownership
RUN useradd -M -s /bin/bash -N -u ${NB_UID} ${NB_USER} \
 && mkdir -p ${HOME} \
 && chown -R ${NB_USER}:users ${HOME} \
 && chown -R ${NB_USER}:users /usr/local/bin \
 && chown -R ${NB_USER}:users /etc/s6

# Copy files
COPY ansible-galaxy-requirements.yaml /build/
COPY ansible/ /build/ansible/
WORKDIR /build

# Run ansible-playbook
ARG PLAYBOOK=base
COPY <<EOF /docker-entrypoint-internal.sh
#!/usr/bin/env bash
EOF
RUN chmod 777 /docker-entrypoint-internal.sh \
 && ansible-galaxy collection install -f -r ansible-galaxy-requirements.yaml
RUN --mount=type=ssh ansible-playbook -vvv "hdwlab.notebook_images.${PLAYBOOK}" \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# s6 - 01-copy-tmp-home
RUN mkdir -p /tmp_home \
 && cp -a ${HOME} /tmp_home
COPY <<EOF /etc/cont-init.d/01-copy-tmp-home
#!/usr/bin/with-contenv bash
cp -a -n /tmp_home/* /home/
EOF
WORKDIR ${HOME}

# Set entrypoint
RUN echo 'exec "$@"' >> /docker-entrypoint-internal.sh
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]