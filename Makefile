VENV := .venv
PYTHON := python3
PIP := $(VENV)/bin/pip

.DEFAULT_GOAL := jupyter

.PHONY: jupyter
jupyter: ensure-venv
	$(VENV)/bin/jupyter notebook --notebook-dir=./src

.PHONY: run
run: ensure-venv
	$(VENV)/bin/jupyter nbconvert --to notebook --execute --inplace src/random_play.ipynb

.PHONY: ensure-venv
ensure-venv:
	@test -x $(PYTHON) || (python3 -m venv $(VENV) && echo "✅ Created $(VENV)")
	@$(PIP) install --upgrade pip > /dev/null

.PHONY: setup
setup: ensure-venv
	$(PIP) install -r requirements.txt

.PHONY: lint
lint: ensure-venv
	$(VENV)/bin/flake8 src/

.PHONY: format
format:
	$(VENV)/bin/black src/
	$(VENV)/bin/isort src/

.PHONY: format-check
format-check: ensure-venv
	$(VENV)/bin/black --check src/
	$(VENV)/bin/isort --check-only src/

.PHONY: all
all: lint format-check test

.PHONY: clean
clean:
	rm -rf $(VENV) .mypy_cache .pytest_cache .ruff_cache __pycache__
