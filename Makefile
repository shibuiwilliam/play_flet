DIR := $(shell pwd)

DOCKERFILE := Dockerfile
DOCKER_REPOSITORY := shibui/play_flet

############ COMMON COMMANDS ############
SRC := $(DIR)/src/

.PHONY: lint
lint:
	black --check --diff --line-length 120 $(SRC)

.PHONY: sort
sort:
	isort $(SRC)

.PHONY: fmt
fmt: sort
	black --line-length 120 $(SRC)

.PHONY: vet
vet:
	mypy $(SRC)

.PHONY: install_prettier
install_prettier:
	npm install

.PHONY: format_md
format_md: install_prettier
	npx prettier --write .

.PHONY: req
req:
	poetry export \
		--without-hashes \
		-f requirements.txt \
		--output requirements.txt

.PHONY: install_dep
install_dep:
	pip install -r requirements.txt


############ APP COMMANDS ############
APP_DIR := $(DIR)/
APP_VERSION := 0.0.0
DOCKERFILE_APP = $(APP_DIR)/$(DOCKERFILE)
DOCKER_APP_IMAGE_NAME = $(DOCKER_REPOSITORY):$(APP_VERSION)

.PHONY: build_app
build_app:
	docker build \
		--platform x86_64 \
		-t $(DOCKER_APP_IMAGE_NAME) \
		-f $(DOCKERFILE_APP) \
		.

.PHONY: run_app
run_app:
	docker run \
		-it \
		--rm \
		--name=flet \
		--platform x86_64 \
		$(DOCKER_APP_IMAGE_NAME) \
		python -m src.main

.PHONY: run_with_build
run_with_build: \
	build_app \
	run_app
