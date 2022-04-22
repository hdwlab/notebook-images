FROM ros:noetic as base

USER root

# common environemnt variables
ENV NB_USER jovyan
ENV NB_UID 1000
ENV NB_PREFIX /
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash

# args - software versions
ARG KUBECTL_ARCH="amd64"
ARG KUBECTL_VERSION=v1.21.0
ARG S6_ARCH="amd64"
 # renovate: datasource=github-tags depName=just-containers/s6-overlay versioning=loose
ARG S6_VERSION=v2.2.0.3

# set shell to bash
SHELL ["/bin/bash", "-c"]

# update GPG-key
RUN apt-get update \
 && apt-get install --no-install-recommends curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# install - usefull linux packages
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    apt-transport-https \
    bash \
    bzip2 \
    ca-certificates \
    curl \
    git \
    gnupg \
    gnupg2 \
    locales \
    lsb-release \
    nano \
    software-properties-common \
    tzdata \
    unzip \
    vim \
    wget \
    zip \
    zstd \
    libgl1 \
    libgomp1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install - s6 overlay
RUN export GNUPGHOME=/tmp/ \
 && curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer" -o /tmp/s6-overlay-${S6_VERSION}-installer \
 && chmod +x /tmp/s6-overlay-${S6_VERSION}-installer \
 && /tmp/s6-overlay-${S6_VERSION}-installer / \
 && rm /tmp/s6-overlay-${S6_VERSION}-installer

# install - kubectl
RUN curl -sL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" -o /usr/local/bin/kubectl \
 && curl -sL "https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl.sha256" -o /tmp/kubectl.sha256 \
 && echo "$(cat /tmp/kubectl.sha256) /usr/local/bin/kubectl" | sha256sum --check \
 && rm /tmp/kubectl.sha256 \
 && chmod +x /usr/local/bin/kubectl

# create user and set required ownership
RUN useradd -M -s /bin/bash -N -u ${NB_UID} ${NB_USER} \
 && mkdir -p ${HOME} \
 && chown -R ${NB_USER}:users ${HOME} \
 && chown -R ${NB_USER}:users /usr/local/bin \
 && chown -R ${NB_USER}:users /etc/s6

# set locale configs
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

USER root
RUN apt update -y \
  && apt upgrade -y \
  && apt install -y \
    python3-crypto \
    python3-pip \
    less \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libfreetype6 \
    libxi6 \
  && rm -rf /var/lib/apt/lists/*

# Install poetry
RUN python3 -m pip install --upgrade pip \
  && python3 -m pip install setuptools \
  && python3 -m pip install poetry \
  && rm -rf ~/.cache/pip

# Install jetbrain-projector
RUN python3 -m pip install projector-installer

# Install IDE
RUN mkdir -p /home/${NB_USER}/.projector/configs
RUN projector --accept-license ide autoinstall \
  --config-name PyCharm \
  --ide-name "PyCharm Community Edition 2021.3" \
  --port 8888 \
  --hostname 0.0.0.0 \
  && chown -R ${NB_USER}:users /home/${NB_USER}

# s6 - copy scripts
COPY --chown=jovyan:users s6/ /etc

# s6 - 01-copy-tmp-home
RUN mkdir -p /tmp_home \
 && cp -r ${HOME} /tmp_home \
 && chown -R ${NB_USER}:users /tmp_home

USER $NB_USER

EXPOSE 8888

ENTRYPOINT ["/init"]


#
# For root user mode
#
FROM base as root
USER root

RUN rm -r /root && ln -s /home/jovyan /root