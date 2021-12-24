ARG BASE_IMAGE="public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-scipy:v1.3.0"
FROM ${BASE_IMAGE} as base

# Install common packages
USER root
RUN apt update -y \
  && apt upgrade -y \
  && apt install -y \
    libgl1 \
    libgomp1 \
    patch \
  && rm -rf /var/lib/apt/lists/*
USER ${NB_UID}

# Install Kale
RUN pip install kubeflow-kale==0.7.0 \
  && pip install "jupyterlab>=2.0.0,<3.0.0" \
  && jupyter labextension install kubeflow-kale-labextension

# Install debugger
RUN conda install xeus-python ptvsd \
  && jupyter labextension install @jupyterlab/debugger

# Fix Kale
COPY ./patchfile /opt/patchfile
RUN cd /opt/conda/lib/python3.8/site-packages/kale && patch -p3 < /opt/patchfile

# s6 - copy scripts
COPY --chown=jovyan:users s6/ /etc


#
# For root user mode
#
FROM base as root
USER root