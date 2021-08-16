#!/usr/bin/env bash

function usage() {
  echo "$0 <base-image-list-file> <target-base-name> <target-image-name>"
}

[[ $# -ne 3 ]] && usage && exit 1

# Parse
base_image_list_file=${1}
target_base_name=${2}
target_image_name=${3}

[[ ! -f ${base_image_list_file} ]] && echo "File not found: ${base_image_list_file}" >&2 && exit 1

target_base=$(cat ${base_image_list_file} | awk -v TARGET=${target_base_name} '($1==TARGET){print $2}')

[[ ! "${target_base}" ]] && echo "No such target: ${target_base_name}" >&2 && exit 1


# Build
set -x
DOCKER_BUILDKIT=1 docker build -t ${target_image_name} --build-arg BASE_IMAGE=${target_base} .