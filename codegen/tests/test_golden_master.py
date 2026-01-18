"""
Golden master tests for code generation.

These tests ensure that the generated deribit.json intermediate representation
remains consistent across code changes. Any differences indicate either:
1. A regression that needs to be fixed
2. An intentional change that needs to update the golden master
"""

import json
import os
from pathlib import Path

import pytest


@pytest.fixture
def golden_master_path():
    """Path to the golden master JSON file."""
    return Path(__file__).parent / "fixtures" / "golden_master.json"


@pytest.fixture
def current_output_path():
    """Path to the current generated deribit.json file."""
    return Path(__file__).parent.parent / "deribit.json"


@pytest.fixture
def golden_master(golden_master_path):
    """Load the golden master data."""
    with open(golden_master_path, "r") as f:
        return json.load(f)


@pytest.fixture
def current_output(current_output_path):
    """Load the current output data."""
    if not current_output_path.exists():
        pytest.skip("deribit.json not found - run code generator first")

    with open(current_output_path, "r") as f:
        return json.load(f)


@pytest.mark.golden
def test_endpoint_count(golden_master, current_output):
    """Verify that the number of endpoints hasn't changed."""
    assert len(current_output) == len(golden_master), (
        f"Endpoint count changed: expected {len(golden_master)}, "
        f"got {len(current_output)}"
    )


@pytest.mark.golden
def test_endpoint_names(golden_master, current_output):
    """Verify that all endpoint names match."""
    golden_names = {ep["name"] for ep in golden_master}
    current_names = {ep["name"] for ep in current_output}

    missing = golden_names - current_names
    added = current_names - golden_names

    assert not missing, f"Missing endpoints: {missing}"
    assert not added, f"Added endpoints: {added}"


@pytest.mark.golden
def test_full_golden_master(golden_master, current_output):
    """
    Verify that the entire output matches the golden master.

    This is the comprehensive check. If this fails, compare the diff
    to determine if it's a regression or an intentional change.
    """
    # Sort both by endpoint name for consistent comparison
    golden_sorted = sorted(golden_master, key=lambda x: x["name"])
    current_sorted = sorted(current_output, key=lambda x: x["name"])

    # Compare each endpoint
    for i, (golden_ep, current_ep) in enumerate(zip(golden_sorted, current_sorted)):
        endpoint_name = golden_ep["name"]
        assert current_ep == golden_ep, (
            f"Endpoint '{endpoint_name}' differs from golden master. "
            f"Run 'pytest -vv' to see detailed diff."
        )


@pytest.mark.golden
def test_specific_endpoint_structure(current_output):
    """
    Test that specific critical endpoints have expected structure.

    This catches regressions in important endpoints like authentication.
    """
    endpoints_by_name = {ep["name"]: ep for ep in current_output}

    # Verify public_auth exists and has expected fields
    assert "public_auth" in endpoints_by_name
    public_auth = endpoints_by_name["public_auth"]

    assert "endpoint" in public_auth
    assert "path" in public_auth["endpoint"]
    assert public_auth["endpoint"]["path"] == "/public/auth"

    # Verify it has request and response types
    assert "request_type" in public_auth["endpoint"]
    assert "response_type" in public_auth["endpoint"]

    # Verify the request has grant_type enum
    request_enums = public_auth["endpoint"]["request_type"].get("enums", [])
    enum_names = [e["name"] for e in request_enums]
    assert "grant_type" in enum_names


@pytest.mark.golden
def test_tick_size_steps_structure(current_output):
    """
    Regression test for tick_size_steps structure.

    This specifically tests the fix for the tick_size_steps bug where
    the structure was incorrectly nested.
    """
    endpoints_by_name = {ep["name"]: ep for ep in current_output}

    # Check public_get_instrument
    if "public_get_instrument" in endpoints_by_name:
        endpoint = endpoints_by_name["public_get_instrument"]
        response_types = endpoint["endpoint"].get("response_types", [])

        # Find the result type
        for type_obj in response_types:
            if "tick_size_steps" in [f["name"] for f in type_obj.get("fields", [])]:
                tick_size_field = next(
                    f for f in type_obj["fields"] if f["name"] == "tick_size_steps"
                )

                # Verify it's an array
                assert tick_size_field["type"][
                    "is_array"
                ], "tick_size_steps should be an array"

                # The underlying type should be an object with tick_size and above_price
                # (This is verified implicitly by the full golden master test)
                break


@pytest.mark.golden
def test_public_get_index_price_names_structure(current_output):
    """
    Regression test for public_get_index_price_names response shape.

    This verifies that we model the result as an array type.
    """
    endpoints_by_name = {ep["name"]: ep for ep in current_output}

    if "public_get_index_price_names" in endpoints_by_name:
        endpoint = endpoints_by_name["public_get_index_price_names"]

        # Verify the response returns an array of objects, not strings
        response_type = endpoint["response_type"]
        assert response_type["is_array"] or any(
            f["type"]["is_array"]
            for f in response_type.get("fields", [])
            if f["name"] == "result"
        ), "public_get_index_price_names should return array type"
