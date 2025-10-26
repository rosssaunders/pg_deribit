.PHONY: help install test test-unit test-golden test-integration coverage lint format clean

help:  ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install:  ## Install dependencies
	pip install -r requirements.txt

test:  ## Run all tests
	pytest tests/ -v

test-unit:  ## Run only unit tests
	pytest tests/ -v -m "unit"

test-golden:  ## Run only golden master tests
	pytest tests/ -v -m "golden"

test-integration:  ## Run only integration tests
	pytest tests/ -v -m "integration"

coverage:  ## Run tests with coverage report
	pytest tests/ --cov=. --cov-report=html --cov-report=term-missing
	@echo "Coverage report generated in htmlcov/index.html"

lint:  ## Run linters (black and ruff)
	black --check --diff .
	ruff check .

format:  ## Format code with black
	black .

typecheck:  ## Run mypy type checker
	mypy --install-types --non-interactive .

clean:  ## Clean up generated files
	rm -rf .pytest_cache
	rm -rf htmlcov
	rm -rf .coverage
	rm -rf coverage.xml
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete

update-golden:  ## Update golden master baseline (use after intentional changes)
	@echo "Updating golden master baseline..."
	cp deribit.json tests/fixtures/golden_master.json
	@echo "Golden master updated. Commit this change if the update was intentional."

codegen:  ## Run the code generator
	python main.py
