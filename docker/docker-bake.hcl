group "default" {
  targets = ["common"]
}

variable "BASE_IMAGE" {
  default = "ubuntu:20.04"
#  default = "nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04"
}

variable "IMAGE_NAME" {
  default = "ghcr.io/takedalab/notebook-images"
}

variable "IMAGE_TAG" {
  default = "latest"
}

variable "PLAYBOOK" {
  default = "base"
}

function "base_image_to_output_image_postfix" {
  params = [base_image]
  result = join("-", split(":", join("-", split("/", base_image))))
}

COMMON_IMAGE_NAME_WITH_TAG="${IMAGE_NAME}:${IMAGE_TAG}-${PLAYBOOK}-${base_image_to_output_image_postfix(BASE_IMAGE)}"

target "common" {
  dockerfile = "docker/Dockerfile"
  tags = ["${COMMON_IMAGE_NAME_WITH_TAG}"]
  contexts = {
    base_image = "docker-image://${BASE_IMAGE}"
  }
  args = {
    PLAYBOOK = "${PLAYBOOK}"
  }
}
