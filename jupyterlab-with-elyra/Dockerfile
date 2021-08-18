ARG BASE_IMAGE="public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-scipy:v1.3.0"
FROM ${BASE_IMAGE}

# Install common packages
USER root
RUN apt update -y \
  && apt upgrade -y \
  && apt install -y \
    patch \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

# install - requirements.txt
COPY --chown=jovyan:users requirements.txt /tmp/requirements.txt
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir --use-deprecated=legacy-resolver && \
    rm -f /tmp/requirements.txt

# install elyra
RUN python3 -m pip install --quiet --no-cache-dir --use-deprecated=legacy-resolver elyra==3.0.0

# Update kfp
RUN python3 -m pip install --upgrade --no-cache-dir kfp>=1.7.1

# Fix elyra
COPY ./patchfile /opt/patchfile
RUN cd /opt/conda/lib/python3.8/site-packages/elyra && patch -p2 < /opt/patchfile

RUN jupyter lab build

USER ${NB_UID}
