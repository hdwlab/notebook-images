group "default" {
  targets = ["common"]
}

variable "BASE_IMAGE" {
  default = "ubuntu:20.04"
}

variable "IMAGE_NAME" {
  default = "ghcr.io/hdwlab/notebook-images"
}

variable "IMAGE_TAG" {
  default = "latest"
}

variable "PLAYBOOK" {
  default = "base"
}

function "playbook_image_to_output_name" {
  params = [playbook_image]
  result = join("-", split("_", playbook_image))
}

function "base_image_to_output_image_postfix" {
  params = [base_image]
  result = join("-", split(":", split("/", base_image)[length(split("/", base_image)) - 1]))
}

COMMON_IMAGE_NAME_WITH_TAG="${IMAGE_NAME}:${IMAGE_TAG}-${playbook_image_to_output_name(PLAYBOOK)}-${base_image_to_output_image_postfix(BASE_IMAGE)}"

target "common" {
  dockerfile = "docker/Dockerfile"
  tags = ["${COMMON_IMAGE_NAME_WITH_TAG}"]
  contexts = {
    base_image = "docker-image://${BASE_IMAGE}"
  }
  args = {
    PLAYBOOK = "${PLAYBOOK}"
  }
  cache-from = ["${COMMON_IMAGE_NAME_WITH_TAG}"]
}
