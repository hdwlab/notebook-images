group "default" {
  targets = ["base-cpu", "base-cuda"]
}

variable "TAG" {
  default = "latest"
}

variable "UBUNTU_VERSION" {
  default = "20.04"
}

variable "CUDA_VERSION" {
  default = "11.6.2"
}

variable "CUDNN_VERSION" {
  default = "8"
}

target "base" {
  dockerfile = "docker/Dockerfile"
}

target "base-cpu" {
  inherits = ["base"]
  tags = ["ghcr.io/takedalab/notebook-base:${TAG}-ubuntu-${UBUNTU_VERSION}-cpu"]
  contexts = {
    base_image = "docker-image://ubuntu:${UBUNTU_VERSION}"
  }
}

target "base-cuda" {
  inherits = ["base"]
  tags = ["ghcr.io/takedalab/notebook-base:${TAG}-ubuntu-${UBUNTU_VERSION}-cuda-${CUDA_VERSION}"]
  contexts = {
    base_image = "docker-image://nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime-ubuntu${UBUNTU_VERSION}"
  }
}
