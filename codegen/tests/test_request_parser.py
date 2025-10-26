"""Unit tests for request parser."""

import pandas as pd
import pytest
from bs4 import BeautifulSoup

from deribit.request_parser import (
    ComplexTypeBuilder,
    RequestRow,
    RequestTableParser,
    request_table_to_type,
)
from models.models import TypeDefinition


@pytest.mark.unit
class TestRequestRow:
    """Test RequestRow."""

    def test_is_array_for_array_of_objects(self):
        row = RequestRow(
            name="items", required="true", type_="array of objects", enum="", description="Items"
        )
        assert row.is_array() is True

    def test_is_array_for_generic_array(self):
        row = RequestRow(
            name="tags", required="false", type_="array", enum="", description="Tags"
        )
        assert row.is_array() is True

    def test_is_array_for_string_or_array(self):
        row = RequestRow(
            name="data",
            required="false",
            type_="string or array of strings",
            enum="",
            description="Data",
        )
        assert row.is_array() is True

    def test_is_primitive_for_string(self):
        row = RequestRow(
            name="name", required="true", type_="string", enum="", description="Name"
        )
        assert row.is_primitive() is True

    def test_is_primitive_for_number(self):
        row = RequestRow(
            name="price", required="true", type_="number", enum="", description="Price"
        )
        assert row.is_primitive() is True

    def test_is_enum_with_enum_values(self):
        row = RequestRow(
            name="type",
            required="true",
            type_="string",
            enum="limit market",
            description="Order type",
        )
        assert row.is_enum() is True

    def test_is_enum_without_enum_values(self):
        row = RequestRow(
            name="name", required="true", type_="string", enum=pd.NA, description="Name"
        )
        assert row.is_enum() is False

    def test_enum_items_sorted(self):
        row = RequestRow(
            name="type",
            required="true",
            type_="string",
            enum="market limit stop_limit",
            description="Order type",
        )
        items = row.enum_items()
        assert items == ["limit", "market", "stop_limit"]

    def test_to_field_type_primitive_array(self):
        row = RequestRow(
            name="tags", required="false", type_="array", enum=pd.NA, description="Tags"
        )
        field_type = row.to_field_type()
        assert field_type.name == "string"
        assert field_type.is_array is True
        assert field_type.is_primitive is True

    def test_to_field_type_enum(self):
        row = RequestRow(
            name="type",
            required="true",
            type_="string",
            enum="limit market",
            description="Type",
        )
        field_type = row.to_field_type()
        assert field_type.name == "type"
        assert field_type.is_enum is True
        assert field_type.is_primitive is True

    def test_to_field(self):
        row = RequestRow(
            name="amount", required="true", type_="number", enum=pd.NA, description="Amount"
        )
        field = row.to_field()
        assert field.name == "amount"
        assert field.type.name == "number"
        assert field.required == "true"
        assert field.documentation == "Amount"


@pytest.mark.unit
class TestComplexTypeBuilder:
    """Test ComplexTypeBuilder."""

    def test_parse_complex_type(self):
        # Use HTML parsing like real data
        html_table = """
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>items</td><td>true</td><td>array of objects</td><td></td><td>Items</td></tr>
            <tr><td>  name</td><td>true</td><td>string</td><td></td><td>Item name</td></tr>
            <tr><td>  price</td><td>true</td><td>number</td><td></td><td>Item price</td></tr>
        </table>
        """
        from bs4 import BeautifulSoup

        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")
        df = pd.read_html(str(table))[0]

        builder = ComplexTypeBuilder("test_request")
        rows_consumed = builder.parse(0, df)

        assert builder.name == "test_request_item"
        assert len(builder.fields) == 2
        assert builder.fields[0].name == "name"
        assert builder.fields[1].name == "price"
        assert rows_consumed == 2


@pytest.mark.unit
class TestRequestTableParser:
    """Test RequestTableParser."""

    def test_parse_simple_primitive_fields(self):
        html_table = """
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>instrument_name</td><td>true</td><td>string</td><td></td><td>Instrument name</td></tr>
            <tr><td>amount</td><td>true</td><td>number</td><td></td><td>Amount</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = RequestTableParser()
        result = parser.parse("/public/test", table)

        assert result.name == "public_test_request"
        assert len(result.fields) == 2
        assert result.fields[0].name == "instrument_name"
        assert result.fields[0].type.name == "string"
        assert result.fields[1].name == "amount"
        assert result.fields[1].type.name == "number"

    def test_parse_enum_field(self):
        html_table = """
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>type</td><td>true</td><td>string</td><td>limit market</td><td>Order type</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = RequestTableParser()
        result = parser.parse("/private/buy", table)

        assert len(result.enums) == 1
        assert result.enums[0].type_name == "type"
        assert result.enums[0].items == ["limit", "market"]

    def test_parse_primitive_array(self):
        html_table = """
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>labels</td><td>false</td><td>array</td><td></td><td>Labels</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = RequestTableParser()
        result = parser.parse("/private/test", table)

        assert len(result.fields) == 1
        assert result.fields[0].name == "labels"
        assert result.fields[0].type.is_array is True
        assert result.fields[0].type.is_primitive is True

    def test_parse_complex_array(self):
        html_table = """
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>items</td><td>true</td><td>array of objects</td><td></td><td>Items</td></tr>
            <tr><td>  name</td><td>true</td><td>string</td><td></td><td>Item name</td></tr>
            <tr><td>  price</td><td>true</td><td>number</td><td></td><td>Item price</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = RequestTableParser()
        result = parser.parse("/private/order", table)

        # Should have 1 top-level field: items
        assert len(result.fields) == 1
        assert result.fields[0].name == "items"
        assert result.fields[0].type.is_array is True
        assert result.fields[0].type.is_class is True
        assert result.fields[0].type.name == "private_order_request_item"

        # The complex type should have 2 fields
        assert len(result.fields[0].type.fields) == 2
        assert result.fields[0].type.fields[0].name == "name"
        assert result.fields[0].type.fields[1].name == "price"

    def test_parse_skips_blank_rows(self):
        html_table = """
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>name</td><td>true</td><td>string</td><td></td><td>Name</td></tr>
            <tr><td></td><td></td><td></td><td></td><td></td></tr>
            <tr><td>amount</td><td>true</td><td>number</td><td></td><td>Amount</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        parser = RequestTableParser()
        result = parser.parse("/public/test", table)

        # Should skip the blank row
        assert len(result.fields) == 2
        assert result.fields[0].name == "name"
        assert result.fields[1].name == "amount"


@pytest.mark.unit
class TestRequestTableToType:
    """Test the wrapper function."""

    def test_wrapper_maintains_compatibility(self):
        html_table = """
        <table>
            <tr><th>Parameter</th><th>Required</th><th>Type</th><th>Enum</th><th>Description</th></tr>
            <tr><td>test</td><td>true</td><td>string</td><td></td><td>Test</td></tr>
        </table>
        """
        soup = BeautifulSoup(html_table, "html.parser")
        table = soup.find("table")

        result = request_table_to_type("/public/test", table)

        assert isinstance(result, TypeDefinition)
        assert result.name == "public_test_request"
        assert len(result.fields) == 1
