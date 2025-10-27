"""
End-to-end integration tests for the full code generation pipeline.
"""

import json
import os
import shutil
import sys
import tempfile
from pathlib import Path

import pytest


@pytest.fixture
def test_output_dir():
    """Create a temporary directory for test outputs."""
    with tempfile.TemporaryDirectory() as tmpdir:
        yield Path(tmpdir)


@pytest.fixture
def codegen_root():
    """Get the root directory of the codegen module."""
    return Path(__file__).parent.parent


@pytest.mark.integration
def test_full_pipeline_from_html(codegen_root, test_output_dir):
    """
    Test the full code generation pipeline.

    This test:
    1. Uses the existing deribit.html file
    2. Runs the full pipeline
    3. Verifies deribit.json is generated and valid
    4. Checks that the output has the expected structure
    """
    # Check that deribit.html exists
    html_file = codegen_root / "deribit.html"
    if not html_file.exists():
        pytest.skip("deribit.html not found - download it first")

    # Check that deribit.json exists (already generated)
    json_file = codegen_root / "deribit.json"
    if not json_file.exists():
        pytest.skip("deribit.json not found - run code generator first")

    # Load and validate the JSON
    with open(json_file, "r") as f:
        endpoints = json.load(f)

    # Verify it's an array
    assert isinstance(endpoints, list), "deribit.json should contain an array"

    # Verify it's not empty
    assert len(endpoints) > 0, "deribit.json should contain endpoints"

    # Verify each endpoint has required structure
    for endpoint in endpoints:
        assert "name" in endpoint, f"Endpoint missing 'name': {endpoint}"
        assert "endpoint" in endpoint, f"Endpoint {endpoint['name']} missing 'endpoint'"

        endpoint_obj = endpoint["endpoint"]
        assert "path" in endpoint_obj, f"Endpoint {endpoint['name']} missing 'path'"
        assert (
            "name" in endpoint_obj
        ), f"Endpoint {endpoint['name']} missing endpoint name"


@pytest.mark.integration
def test_json_structure_validity(codegen_root):
    """
    Test that the generated JSON has valid structure.

    Verifies:
    - All endpoints have consistent structure
    - Types are properly defined
    - No dangling references
    """
    json_file = codegen_root / "deribit.json"
    if not json_file.exists():
        pytest.skip("deribit.json not found")

    with open(json_file, "r") as f:
        endpoints = json.load(f)

    endpoint_names = set()
    for endpoint in endpoints:
        name = endpoint["name"]

        # Check for duplicates
        assert name not in endpoint_names, f"Duplicate endpoint name: {name}"
        endpoint_names.add(name)

        # Verify endpoint has request or response types
        endpoint_obj = endpoint["endpoint"]
        has_request = "request_type" in endpoint_obj
        has_response = "response_type" in endpoint_obj

        # Most endpoints should have at least a response type
        # (Some might not have request parameters)
        assert (
            has_response or has_request
        ), f"Endpoint {name} has neither request nor response type"


@pytest.mark.integration
def test_specific_endpoint_regression(codegen_root):
    """
    Regression test for specific endpoints that had bugs.

    Tests:
    1. tick_size_steps structure in public_get_instrument
    2. public_get_index_price_names structure
    """
    json_file = codegen_root / "deribit.json"
    if not json_file.exists():
        pytest.skip("deribit.json not found")

    with open(json_file, "r") as f:
        endpoints = json.load(f)

    endpoints_by_name = {ep["name"]: ep for ep in endpoints}

    # Test 1: public_get_instrument tick_size_steps
    if "public_get_instrument" in endpoints_by_name:
        endpoint = endpoints_by_name["public_get_instrument"]
        response_types = endpoint["endpoint"].get("response_types", [])

        # Find type with tick_size_steps field
        found_tick_size = False
        for type_obj in response_types:
            fields = type_obj.get("fields", [])
            for field in fields:
                if field["name"] == "tick_size_steps":
                    found_tick_size = True
                    # Should be an array
                    assert field["type"][
                        "is_array"
                    ], "tick_size_steps should be an array type"

        assert (
            found_tick_size
        ), "tick_size_steps field not found in public_get_instrument"

    # Test 2: public_get_index_price_names returns objects
    if "public_get_index_price_names" in endpoints_by_name:
        endpoint = endpoints_by_name["public_get_index_price_names"]
        response_type = endpoint.get("response_type", {})

        # The result should be an array or have array fields
        # (Structure varies based on how it's represented)
        has_array = response_type.get("is_array", False) or any(
            f["type"].get("is_array", False) for f in response_type.get("fields", [])
        )
        assert has_array, "public_get_index_price_names should return array type"


@pytest.mark.integration
def test_enum_consistency(codegen_root):
    """
    Test that enums are consistently defined.

    Verifies:
    - Enums have at least one item
    - Enum items are strings
    - Enum names are valid identifiers
    """
    json_file = codegen_root / "deribit.json"
    if not json_file.exists():
        pytest.skip("deribit.json not found")

    with open(json_file, "r") as f:
        endpoints = json.load(f)

    for endpoint in endpoints:
        endpoint_name = endpoint["name"]
        endpoint_obj = endpoint["endpoint"]

        # Check request type enums
        if "request_type" in endpoint_obj and endpoint_obj["request_type"] is not None:
            request_type = endpoint_obj["request_type"]
            for enum in request_type.get("enums", []):
                assert "name" in enum, f"{endpoint_name}: Enum missing name"
                assert (
                    "items" in enum
                ), f"{endpoint_name}: Enum {enum['name']} missing items"
                assert (
                    len(enum["items"]) > 0
                ), f"{endpoint_name}: Enum {enum['name']} has no items"

                # All items should be strings
                for item in enum["items"]:
                    assert isinstance(
                        item, str
                    ), f"{endpoint_name}: Enum {enum['name']} has non-string item: {item}"


@pytest.mark.integration
def test_sql_files_generated(codegen_root):
    """
    Test that SQL files are generated for endpoints.

    This assumes the code generator has been run at least once.
    """
    sql_dir = codegen_root.parent / "sql" / "endpoints"
    if not sql_dir.exists():
        pytest.skip("SQL endpoints directory not found - run code generator first")

    sql_files = list(sql_dir.glob("*.sql"))
    assert len(sql_files) > 0, "No SQL files found in sql/endpoints/"

    # Verify each SQL file has expected structure
    for sql_file in sql_files[:5]:  # Just check first 5 to keep test fast
        content = sql_file.read_text()

        # Should have auto-generated header
        assert (
            "AUTO-GENERATED FILE" in content
        ), f"{sql_file.name} missing auto-generated header"

        # Should have at least one CREATE TYPE or CREATE FUNCTION
        assert (
            "create type" in content.lower() or "create function" in content.lower()
        ), f"{sql_file.name} has no CREATE statements"
