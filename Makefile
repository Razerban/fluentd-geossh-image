DOCKER_REPO             ?= razerban
DOCKER_IMAGE_NAME		?= fluentd-geossh
DOCKER_IMAGE_TAG        ?= $(subst /,-,$(shell git describe --tags --abbrev=0))

DOCKER_PLATFORMS        ?= linux/arm/v6,linux/arm/v7,linux/arm64,linux/amd64

.PHONY: docker
docker: docker-build

.PHONY: docker-build
docker-build:
	docker build -t "$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" .

.PHONY: docker-buildx
docker-buildx:
	docker buildx build -t "$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" -t "$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):latest" \
		--platform "$(DOCKER_PLATFORMS)" \
		.

.PHONY: docker-buildx-publish
docker-buildx-publish: docker-publish

.PHONY: docker-publish
docker-publish:
	docker buildx build -t "$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" -t "$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):latest" \
		--platform "$(DOCKER_PLATFORMS)" \
		--push \
		.

.PHONY: docker-compose
docker-compose:
	docker compose up -v
