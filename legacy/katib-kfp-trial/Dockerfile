FROM gcr.io/arrikto/katib-kfp-trial:a7f7bb79-d9bf99ac as base

# Install common packages
USER root
RUN apt update -y \
  && apt upgrade -y \
  && apt install -y \
    patch \
  && rm -rf /var/lib/apt/lists/*
USER ${NB_UID}

# Fix Kale
RUN pip install --upgrade kubeflow-kale==0.7.0 kfp==1.7.1 kfp-server-api==1.6.0 kfp-pipeline-spec==0.1.9
COPY ./patchfile /opt/patchfile
RUN cd /usr/local/lib/python3.6/site-packages/kale && patch -p3 < /opt/patchfile


#
# For root user mode
#
FROM base as root
USER root