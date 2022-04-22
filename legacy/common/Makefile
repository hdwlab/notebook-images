#
# Makefile
#

VERSION ?= $(shell ../utils/get-version.sh)
COMMIT_ID := $(shell git rev-parse HEAD)

IMAGE_PREFIX ?= ghcr.io/takedalab
IMAGE_NAME ?= $(shell basename ${PWD})
$(warning Image: $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION))

DEFAULT_ROOT_USER ?= false

help: ## Show this help
	@echo "Help"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[36m%-20s\033[93m %s\n", $$1, $$2}'

.PHONY: default
default: help

.PHONY: build
build:	## Build an image
	$(DEFAULT_ROOT_USER) \
	&& DOCKER_BUILDKIT=1 docker build -t $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)$(IMAGE_TAG_POSTFIX) --target root . \
	|| DOCKER_BUILDKIT=1 docker build -t $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)$(IMAGE_TAG_POSTFIX) --target base .

.PHONY: publish
publish:    ## Publish an image
	docker push $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)$(IMAGE_TAG_POSTFIX)

.PHONY: run
run:    ## Run an image
	docker run -it --rm -p 8888:8888 $(IMAGE_PREFIX)/$(IMAGE_NAME):$(VERSION)$(IMAGE_TAG_POSTFIX)

.PHONY: root.%
root.%:	## Enable root-user
	export DEFAULT_ROOT_USER=true && export IMAGE_TAG_POSTFIX=-root && make $*