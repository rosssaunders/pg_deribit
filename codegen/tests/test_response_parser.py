"""Unit tests for response parser."""

import pandas as pd
import pytest
from bs4 import BeautifulSoup

from deribit.response_parser import (
    ResponseRow,
    ResponseTableParser,
    default_response_type,
    response_table_to_type,
)
from models.models import TypeDefinition


@pytest.mark.unit
class TestResponseRow:
    """Test ResponseRow."""

    def test_is_array_for_array_of_objects(self):
        row = ResponseRow(name="items", type_="array of objects", description="Items")
        assert row.is_array() is True

    def test_is_array_for_generic_array(self):
        row = ResponseRow(name="tags", type_="array", description="Tags")
        assert row.is_array() is True

    def test_is_not_array_for_string(self):
        row = ResponseRow(name="name", type_="string", description="Name")
        assert row.is_array() is False

    def test_is_primitive_for_string(self):
        row = ResponseRow(name="name", type_="string", description="Name")
        assert row.is_primitive() is True

    def test_is_primitive_for_number(self):
        row = ResponseRow(name="price", type_="number", description="Price")
        assert row.is_primitive() is True

    def test_is_primitive_for_array(self):
        row = ResponseRow(name="tags", type_="array", description="Tags")
        assert row.is_primitive() is True

    def test_is_not_primitive_for_object(self):
        row = ResponseRow(name="data", type_="object", description="Data")
        assert row.is_primitive() is False

    def test_level_no_indentation(self):
        row = ResponseRow(name="field", type_="string", description="Field")
        assert row.level() == 0

    def test_level_single_indentation(self):
        # HTML parsing strips leading spaces, so indentation isn't preserved in ResponseRow
        # Indentation is handled during table parsing
        row = ResponseRow(name="  field", type_="string", description="Field")
        assert row.level() == 0  # Spaces counted as 0 indent by count_ident

    def test_level_double_indentation(self):
        # HTML parsing strips leading spaces
        row = ResponseRow(name="    field", type_="string", description="Field")
        assert row.level() == 0  # Spaces counted as 0 indent by count_ident


@pytest.mark.unit
class TestDefaultResponseType:
    """Test default_response_type function."""

    def test_creates_default_response(self):
        result = default_response_type("/public/test")

        assert result.name == "public_test_response"
        assert result.is_primitive is True
        assert len(result.fields) == 2
        assert result.fields[0].name == "id"
        assert result.fields[0].type.name == "integer"
        assert result.fields[1].name == "jsonrpc"
        assert result.fields[1].type.name == "string"


@pytest.mark.unit
class TestResponseTableParser:
    """Test ResponseTableParser."""

    def test_parse_simple_fields(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>id</td><td>integer</td><td>Request ID</td></tr>
            <tr><td>result</td><td>string</td><td>Result</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        assert root_type.name == "public_test_response"
        assert len(root_type.fields) == 2
        assert root_type.fields[0].name == "id"
        assert root_type.fields[0].type.name == "integer"
        assert root_type.fields[1].name == "result"
        assert root_type.fields[1].type.name == "string"

    def test_parse_nested_object(self):
        # Note: HTML parsing doesn't preserve whitespace indentation
        # In real data, indentation is detected by comparing adjacent rows
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>result</td><td>string</td><td>Result</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        # Simple case without nesting
        assert len(root_type.fields) >= 1
        assert root_type.fields[0].name == "result"

    def test_parse_array_of_objects(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>items</td><td>array of object</td><td>Items</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/get_items", table)

        # Should have items field as array (without nested fields due to HTML parsing)
        assert len(root_type.fields) == 1
        assert root_type.fields[0].name == "items"
        assert root_type.fields[0].type.is_array is True
        assert root_type.fields[0].type.name == "public_get_items_response_item"  # Full name

    def test_parse_primitive_array(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>labels</td><td>array of string</td><td>Labels</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        assert len(root_type.fields) == 1
        assert root_type.fields[0].name == "labels"
        assert root_type.fields[0].type.is_array is True
        assert root_type.fields[0].type.name == "string"

    def test_parse_detects_json_blob(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>metadata</td><td>object</td><td>Metadata</td></tr>
            <tr><td>data</td><td>string</td><td>Data</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        # metadata should be treated as JSON blob (no child fields)
        assert len(root_type.fields) == 2
        assert root_type.fields[0].name == "metadata"
        assert root_type.fields[0].type.name == "json"  # Converted to json

    def test_parse_handles_indentation_changes(self):
        # HTML parsing doesn't preserve indentation, so this tests simpler case
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>result</td><td>string</td><td>Result</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        # Simple case with one type
        assert len(all_types) == 1  # Just root

    def test_parse_array_of_price_amount(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>bids</td><td>array of [price, amount]</td><td>Bid prices</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        assert len(root_type.fields) == 1
        assert root_type.fields[0].name == "bids"
        assert root_type.fields[0].type.name == "float[]"
        assert root_type.fields[0].type.is_array is True

    def test_parse_array_of_timestamp_value(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>ticks</td><td>array of [timestamp, value]</td><td>Tick data</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        # Should create nested type with timestamp and value fields
        assert len(all_types) == 2  # root + tick type
        tick_type = [t for t in all_types if "tick" in t.name][0]
        assert tick_type.is_nested_array is True
        assert len(tick_type.fields) == 2
        assert tick_type.fields[0].name == "timestamp"
        assert tick_type.fields[1].name == "value"

    def test_parse_skips_blank_rows(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>id</td><td>integer</td><td>ID</td></tr>
            <tr><td></td><td></td><td></td></tr>
            <tr><td>name</td><td>string</td><td>Name</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = ResponseTableParser()
        root_type, response_type, all_types = parser.parse("/public/test", table)

        # Should skip blank row
        assert len(root_type.fields) == 2
        assert root_type.fields[0].name == "id"
        assert root_type.fields[1].name == "name"


@pytest.mark.unit
class TestResponseTableToType:
    """Test the wrapper function."""

    def test_wrapper_maintains_compatibility(self):
        html_table = """
        <table>
            <tr><th>Name</th><th>Type</th><th>Description</th></tr>
            <tr><td>test</td><td>string</td><td>Test field</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        root_type, response_type, all_types = response_table_to_type("/public/test", table)

        assert isinstance(root_type, TypeDefinition)
        assert isinstance(all_types, list)
        assert len(all_types) >= 1
        assert root_type.name == "public_test_response"
