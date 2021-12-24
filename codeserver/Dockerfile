FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/codeserver-python:v1.3.0-rc.1 as base

# Install common packages
USER root
RUN apt update -y \
  && apt upgrade -y \
  && apt install -y \
    openssh-client \
    nodejs \
    npm \
    yarn \
    libgl1 \
    libgomp1 \
  && rm -rf /var/lib/apt/lists/*
USER ${NB_UID}


#
# For root user mode
#
FROM base as root
USER root