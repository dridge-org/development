PYTHON_SRC_DIR = service
DOCKER_RUNNING = $(shell docker info >/dev/null 2>&1 && echo "true" || echo "false")


.PHONY: help
help: ## Display this help text for Makefile
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


.PHONY: check-docker
check-docker:
	@if [ "$(DOCKER_RUNNING)" = "false" ]; then \
		echo "Docker is not running. Please start Docker and try again."; \
		exit 1; \
	fi


.PHONY: install
install: ## Install Python dependencies
	@echo "=> Installing Python dependencies"
	@cd $(PYTHON_SRC_DIR) && poetry install
	@echo "=> Python dependencies installed"

	@echo "=> Installing pre-commit hooks"
	@cd $(PYTHON_SRC_DIR) && poetry run pre-commit install
	@echo "=> Pre-commit hooks installed"


.PHONY: lint
lint: ## Run pre-commit hooks
	@echo "=> Running pre-commit hooks"
	@cd $(PYTHON_SRC_DIR) && poetry run pre-commit run --all-files
	@echo "=> Pre-commit complete"


.PHONY: dev
dev: check-docker ## Start development environment
	@echo "=> Starting development environment"
	@docker-compose -f docker-compose.yml up --build
	@echo "=> Development environment stopped"


.PHONY: build
build: lint ## Build Python package
	@echo "=> Building Python package"
	@cd $(PYTHON_SRC_DIR) && poetry build
	@echo "=> Python package build complete"


.PHONY: clean
clean: ## Clean build artifacts
	@echo "=> Cleaning build artifacts"
	@rm -rf $(PYTHON_SRC_DIR)/dist/
	@rm -rf $(PYTHON_SRC_DIR)/build/
	@rm -rf $(PYTHON_SRC_DIR)/.ruff_cache/
	@rm -rf $(PYTHON_SRC_DIR)/.pytest_cache/
	@find $(PYTHON_SRC_DIR) -name '*.pyc' -exec rm -f {} +
	@find $(PYTHON_SRC_DIR) -name '*.pyo' -exec rm -f {} +
	@find $(PYTHON_SRC_DIR) -name '*~' -exec rm -f {} +
	@find $(PYTHON_SRC_DIR) -name '__pycache__' -exec rm -rf {} +
	@find $(PYTHON_SRC_DIR) -name '.pytest_cache' -exec rm -rf {} +
	@find $(PYTHON_SRC_DIR) -name '.ipynb_checkpoints' -exec rm -rf {} +
