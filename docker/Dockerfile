#syntax=docker/dockerfile:1.4

FROM base_image as devel
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set locale
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install fundamental packages
RUN apt update \
  && DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends \
    git \
    ssh \
    software-properties-common \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN add-apt-repository --yes --update ppa:ansible/ansible \
  && apt update \
  && DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends \
    ansible \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Add GitHub to known hosts for private repositories
RUN mkdir -p ~/.ssh \
  && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Copy files
COPY ansible-galaxy-requirements.yaml /build/
COPY ansible/ /build/ansible/
WORKDIR /build

# Run ansible-playbook
ARG PLAYBOOK=base
RUN ansible-galaxy collection install -f -r ansible-galaxy-requirements.yaml
RUN --mount=type=ssh ansible-playbook -v "takedalab.notebook_images.${PLAYBOOK}"
