FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/base:master-6c41e72b as base

USER root
RUN apt update -y \
  && apt upgrade -y \
  && apt install -y \
    openssh-client \
    nodejs \
    npm \
    yarn \
    python3-crypto \
    python3-pip \
    less \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libfreetype6 \
    libxi6 \
    libgl1 \
    libgomp1 \
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
  --ide-name "PyCharm Community Edition 2021.1.2" \
  --port 8888 \
  --hostname 0.0.0.0 \
  && chown -R ${NB_USER}:users /home/${NB_USER}

# s6 - copy scripts
COPY --chown=jovyan:users s6/ /etc

# s6 - 01-copy-tmp-home
RUN mkdir -p /tmp_home \
 && cp -r ${HOME} /tmp_home \
 && chown -R ${NB_USER}:users /tmp_home

USER $NB_UID

EXPOSE 8888

ENTRYPOINT ["/init"]


#
# For root user mode
#
FROM base as root
USER root