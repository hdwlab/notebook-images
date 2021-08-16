FROM public.ecr.aws/j1r0q0g6/notebooks/notebook-servers/jupyter-scipy:v1.3.0

# Install Kale
RUN pip install kubeflow-kale \
  && pip install "jupyterlab>=2.0.0,<3.0.0" \
  && jupyter labextension install kubeflow-kale-labextension