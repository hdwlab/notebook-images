#
# Makefile
#

VERSION ?= $(shell ../utils/get-version.sh)
COMMIT_ID := $(shell git rev-parse HEAD)

BUILD_BASE_IMAGES_FILE := ./base_images.txt
BUILD_LIST := $(shell cat ${BUILD_BASE_IMAGES_FILE} | awk '{print $$1}')
$(warning Available base image names: $(BUILD_LIST))

IMAGE_PREFIX ?= ghcr.io/takedalab
IMAGE_NAME ?= $(shell basename ${PWD})
$(warning Image: $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)-<BASE_NAME>)

help: ## Show this help
	@echo "Help"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[36m%-20s\033[93m %s\n", $$1, $$2}'

.PHONY: default
default: help

.PHONY: build
.PHONY: build.%
BUILD_ALL_IMAGES := $(addprefix build.,$(BUILD_LIST))
build: $(BUILD_ALL_IMAGES)	## Builds all images.
build.%:
	./builder.sh ${BUILD_BASE_IMAGES_FILE} $* $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)-$*

.PHONY: publish
.PHONY: publish.%
PUBLISH_ALL_IMAGES := $(addprefix publish.,$(BUILD_LIST))
publish: $(PUBLISH_ALL_IMAGES)	## Builds all images.
publish.%:
	docker push $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)-$*

.PHONY: run.%
run.%:  ### Run an image
	docker run -it --rm -p 8888:8888 $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)-$*
