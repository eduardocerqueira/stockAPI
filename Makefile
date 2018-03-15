# Variables -------------------------------------------------------------------

NO_COLOR    = \x1b[0m
OK_COLOR    = \x1b[32;01m
WARN_COLOR  = \x1b[50;01m
ERROR_COLOR = \x1b[31;01m
SHELL = bash

# Commands --------------------------------------------------------------------

help:
	@echo -e "Please use $(WARN_COLOR) \`make <target>\'$(NO_COLOR) where $(WARN_COLOR)<target>$(NO_COLOR) is one of"
	@echo -e "  $(OK_COLOR)--- setup ---$(NO_COLOR)"	
	@echo -e "  $(WARN_COLOR)init$(NO_COLOR)              to initialize project, install pip packages and create virtualenv"
	@echo -e "  $(OK_COLOR)--- doc ---$(NO_COLOR)"	
	@echo -e "  $(WARN_COLOR)docs$(NO_COLOR)              to make documentation in the default format"
	@echo -e "  $(WARN_COLOR)docs-clean$(NO_COLOR)        to remove docs and doc build artifacts"
	@echo -e "  $(OK_COLOR)--- code ---$(NO_COLOR)"	
	@echo -e "  $(WARN_COLOR)codecheck$(NO_COLOR)         to run code check on the entire project"
	@echo -e "  $(WARN_COLOR)gitflake8$(NO_COLOR)         to check flake8 styling only for modified files"
	@echo -e "  $(WARN_COLOR)clean-cache$(NO_COLOR)       to clean pytest cache files"
	@echo -e "  $(WARN_COLOR)clean-all$(NO_COLOR)         to clean cache, pyc, logs and docs"
	@echo -e "  $(WARN_COLOR)clean-pyc$(NO_COLOR)         to delete all temporary artifacts"
	@echo -e "  $(OK_COLOR)--- run tests ---$(NO_COLOR)"	
	@echo -e "  $(WARN_COLOR)tests$(NO_COLOR)             run all tests"
	@echo -e "$(NO_COLOR)"

# Targets ---------------------------------------------------------------------

.PHONY: help docs docs-clean lint pyc-clean \
		can-i-push? gitflake8 clean-cache clean-all tests

init: clean_venv
	scripts/virtualenv.sh

clean_venv:
	rm -rf venv

docs:
	@cd docs; sphinx-apidoc -f -o source/ ../../stockAPI/src/
	@cd docs; $(MAKE) html

docs-clean:
	$(info "Cleaning docs...")
	@cd docs; $(MAKE) clean

codecheck: 
	@echo -e "$(WARN_COLOR)----Starting PEP8 code analysis----$(NO_COLOR)"
	find src/ -name "*.py" | xargs pep8 \
	--verbose --statistics --count --show-pep8 --exclude=.eggs
	@echo -e "$(WARN_COLOR)----Starting Pylint code analysis----$(NO_COLOR)"
	find src/ -name "*.py" | xargs pylint --rcfile=pylintrc
	@echo

gitflake8:
	$(info "Checking style and syntax errors with flake8 linter...")
	@flake8 $(shell git diff --name-only | grep ".py$$") tests/__init__.py --show-source

clean-cache:
	$(info "Cleaning the .cache directory...")
	rm -rf .cache

clean-all: docs-clean pyc-clean clean-cache

clean-pyc: ## remove Python file artifacts
	$(info "Removing unused Python compiled files, caches and ~ backups...")
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

tests:
	@echo -e "$(WARN_COLOR)----Running tests----$(NO_COLOR)"
	@pytest -v src/tests
