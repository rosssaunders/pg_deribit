# Code Generator Test Suite

This directory contains comprehensive tests for the pg_deribit code generator.

## Test Organization

### Golden Master Tests (`test_golden_master.py`)
Golden master tests ensure that generated code remains consistent across changes. These tests:
- Compare current output against a known-good baseline
- Catch unintended changes in code generation
- Include regression tests for specific bugs (tick_size_steps, public_get_index_price_names)

**Markers**: `@pytest.mark.golden`

### Integration Tests (`test_integration.py`)
End-to-end tests that verify the full code generation pipeline:
- HTML parsing → JSON IR → SQL generation
- Structural validation of generated endpoints
- Enum consistency checks
- SQL file generation validation

**Markers**: `@pytest.mark.integration`

### Unit Tests (`test_*.py`)
Tests for individual utility functions:
- `test_name_utils.py`: String manipulation, pluralization, type naming
- `test_json_utils.py`: Custom JSON encoding for numpy types

**Markers**: `@pytest.mark.unit`

## Running Tests

### Using Make (Recommended)
```bash
# Run all tests
make test

# Run specific test categories
make test-unit
make test-golden
make test-integration

# Generate coverage report
make coverage

# Run linters
make lint
```

### Using pytest directly
```bash
# All tests
pytest tests/ -v

# Specific markers
pytest tests/ -v -m "unit"
pytest tests/ -v -m "golden"
pytest tests/ -v -m "integration"

# With coverage
pytest tests/ --cov=. --cov-report=html
```

## Test Coverage

Current coverage (as of Phase 1 completion):
- **Unit tests**: 100% coverage of `name_utils.py` and `json_utils.py`
- **Golden master tests**: Baseline established for 149 endpoints
- **Integration tests**: Full pipeline validation

Target coverage after Phase 3: **95%+**

## Golden Master Workflow

### When Tests Fail
If golden master tests fail:

1. **Check if the change was intentional**:
   ```bash
   # Compare current output with baseline
   diff codegen/deribit.json codegen/tests/fixtures/golden_master.json
   ```

2. **If change was intentional** (e.g., Deribit API update):
   ```bash
   # Update the golden master
   make update-golden

   # Commit the change
   git add codegen/tests/fixtures/golden_master.json
   git commit -m "chore: update golden master for API changes"
   ```

3. **If change was unintentional**:
   - Fix the code generation logic
   - Re-run tests to verify fix

## Fixtures

- `fixtures/golden_master.json`: Baseline snapshot of deribit.json (149 endpoints)
- Future: Add sample HTML fragments for parser testing

## CI/CD Integration

Tests run automatically on GitHub Actions:
- **Triggers**: Push to `main` or `update-deribit-api`, PRs to `main`
- **Python versions**: 3.11, 3.12, 3.13
- **Checks**: Unit tests, golden master, integration, linting, type checking
- **Artifacts**: Coverage reports uploaded to Codecov

## Development Workflow

1. **Before making changes**:
   ```bash
   make test  # Ensure baseline passes
   ```

2. **After making changes**:
   ```bash
   make test          # Run all tests
   make coverage      # Check coverage
   make lint          # Check code style
   make typecheck     # Check types
   ```

3. **If golden master needs update**:
   ```bash
   make update-golden
   ```

## Writing New Tests

### Adding a Unit Test
```python
@pytest.mark.unit
def test_my_function():
    result = my_function("input")
    assert result == "expected"
```

### Adding a Golden Master Test
```python
@pytest.mark.golden
def test_my_endpoint_structure(current_output):
    endpoints = {ep['name']: ep for ep in current_output}
    assert 'my_endpoint' in endpoints
    # ... assertions
```

### Adding an Integration Test
```python
@pytest.mark.integration
def test_my_pipeline_feature(codegen_root):
    # ... test full pipeline behavior
```

## Known Issues / Future Improvements

From Phase 1 completion:
- ✅ Golden master baseline established
- ✅ Unit tests for utilities
- ✅ Integration tests for pipeline
- ⏳ Phase 2: Improve code quality (PEP 8, type hints, logging)
- ⏳ Phase 3: Refactor architecture (type registry, strategy pattern)
- ⏳ Phase 4: Advanced improvements (JSON schema, better errors)

## Questions?

See the main codegen README.md or the Phase 1 implementation summary in the project documentation.
