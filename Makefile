SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export PROJECT=app

targets: help

build: ## Build the application
	docker build . -t gluck0101/oridosai-txt2img

push: ## Push the application to docker hub
	docker push gluck0101/oridosai-txt2img

up: ## Run the application
	docker run --rm -it  -p 8000:8000/tcp gluck0101/oridosai-txt2img:latest

done: lint test ## Prepare for a commit
test: utest itest  ## Run unit and integration tests

ci-docker-compose := docker-compose -f .ci/docker-compose.yml

utest: cleantest ## Run unit tests
	$(ci-docker-compose) run --rm unit pytest -m unit .

itest: cleantest ## Run integration tests
	$(ci-docker-compose) run --rm integration pytest -m integration .

check: ## Check the code base
	$(ci-docker-compose) run --rm unit black ./$(PROJECT) --check --diff
	$(ci-docker-compose) run --rm unit isort ./$(PROJECT) --check --diff
	$(ci-docker-compose) run --rm -v mypycache:/app/.mypy_cache unit mypy ./$(PROJECT)

lint: ## Check the code base, and fix it
	$(ci-docker-compose) run --rm unit black ./$(PROJECT)
	$(ci-docker-compose) run --rm unit isort ./$(PROJECT)
	$(ci-docker-compose) run --rm -v mypycache:/app/.mypy_cache unit mypy ./$(PROJECT)

cleantest:  ## Clean up test containers
	$(ci-docker-compose) build
	$(ci-docker-compose) down --remove-orphans
