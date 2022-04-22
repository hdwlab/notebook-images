FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/base:master-6c41e72b as base

USER root

# args - software versions
ARG MINIFORGE_ARCH="x86_64"
 # renovate: datasource=github-tags depName=conda-forge/miniforge versioning=loose
ARG MINIFORGE_VERSION=4.10.1-4
ARG PIP_VERSION=21.1.2
ARG PYTHON_VERSION=3.8.10

# setup environment for conda
ENV CONDA_DIR /opt/conda
ENV PATH "${CONDA_DIR}/bin:${PATH}"
RUN mkdir -p ${CONDA_DIR} \
 && echo ". /opt/conda/etc/profile.d/conda.sh" >> ${HOME}/.bashrc \
 && echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile \
 && echo "conda activate base" >> ${HOME}/.bashrc \
 && echo "conda activate base" >> /etc/profile \
 && chown -R ${NB_USER}:users ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# switch to NB_UID for installs
USER ${NB_UID}

# install - conda, pip, python
RUN curl -sL "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-${MINIFORGE_ARCH}.sh" -o /tmp/Miniforge3.sh \
 && curl -sL "https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-${MINIFORGE_ARCH}.sh.sha256" -o /tmp/Miniforge3.sh.sha256 \
 && echo "$(cat /tmp/Miniforge3.sh.sha256 | awk '{ print $1; }') /tmp/Miniforge3.sh" | sha256sum --check \
 && rm /tmp/Miniforge3.sh.sha256 \
 && /bin/bash /tmp/Miniforge3.sh -b -f -p ${CONDA_DIR} \
 && rm /tmp/Miniforge3.sh \
 && conda config --system --set auto_update_conda false \
 && conda config --system --set show_channel_urls true \
 && echo "conda ${MINIFORGE_VERSION:0:-2}" >> ${CONDA_DIR}/conda-meta/pinned \
 && echo "python ${PYTHON_VERSION}" >> ${CONDA_DIR}/conda-meta/pinned \
 && conda install -y -q \
    python=${PYTHON_VERSION} \
    conda=${MINIFORGE_VERSION:0:-2} \
    pip=${PIP_VERSION} \
 && conda update -y -q --all \
 && conda clean -a -f -y \
 && chown -R ${NB_USER}:users ${CONDA_DIR} \
 && chown -R ${NB_USER}:users ${HOME}

# nvidia configs
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt

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

USER $NB_UID

EXPOSE 8888

ENTRYPOINT ["/init"]


#
# For root user mode
#
FROM base as root
USER root

RUN rm -r /root && ln -s /home/jovyan /root