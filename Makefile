PACKAGE := forked_flake8_cached

# MAIN TASKS ##################################################################

.PHONY: all
all: install

.PHONY: ci
ci: format check ## Run all tasks that determine CI status

.PHONY: run ## Start the program
run: install
	poetry run python $(PACKAGE)/__main__.py

VIRTUAL_ENV ?= .venv
DEPENDENCIES := $(VIRTUAL_ENV)/.poetry-$(shell bin/checksum pyproject.toml poetry.lock)

.PHONY: install
install: $(DEPENDENCIES) .cache

$(DEPENDENCIES): poetry.lock
	@ rm -rf $(VIRTUAL_ENV)/.poetry-*
	@ poetry config virtualenvs.in-project true
	poetry install
	@ touch $@

ifndef CI
poetry.lock: pyproject.toml
	poetry lock --no-update
	@ touch $@
endif

.cache:
	@ mkdir -p .cache

# CHECKS ######################################################################

.PHONY: format
format: install
	poetry run isort $(PACKAGE)
	poetry run black $(PACKAGE)
	@ echo

.PHONY: check
check: install format  ## Run formaters, linters, and static analysis
ifdef CI
	git diff --exit-code
endif
	poetry run mypy $(PACKAGE) tests --config-file=.mypy.ini

# HELP ########################################################################

.PHONY: help
help: all
	@ grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
