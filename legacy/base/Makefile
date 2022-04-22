#
# Makefile
#

VERSION ?= $(shell ../utils/get-version.sh)
COMMIT_ID := $(shell git rev-parse HEAD)

IMAGE_PREFIX ?= ghcr.io/takedalab
IMAGE_NAME ?= $(shell basename ${PWD})
$(warning Image: $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)$(IMAGE_TAG_POSTFIX))

help: ## Show this help
	@echo "Help"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[36m%-20s\033[93m %s\n", $$1, $$2}'

.PHONY: default
default: help

.PHONY: build
build:	## Build an image
	$(ENABLE_CUDA) \
	&& DOCKER_BUILDKIT=1 docker build -t $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)$(IMAGE_TAG_POSTFIX) . --target cuda \
	|| DOCKER_BUILDKIT=1 docker build -t $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)$(IMAGE_TAG_POSTFIX) . --target base

.PHONY: build-cpu
build-cpu:	## Build CPU image
	export ENABLE_CUDA=false && export IMAGE_TAG_POSTFIX=-cpu && make build

.PHONY: build-cuda-%
build-cuda-%:	## Build CUDA-enabled image
	export ENABLE_CUDA=true && export CUDA_VERSION=$* && export IMAGE_TAG_POSTFIX=-cuda-$* && make build
