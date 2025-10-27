"""Unit tests for name utility functions."""

import pytest
from utils.name_utils import (
    get_singular_type_name,
    strip_field_name,
    count_ident,
    url_to_type_name,
)


@pytest.mark.unit
class TestGetSingularTypeName:
    """Test get_singular_type_name function."""

    def test_singular_field_name(self):
        """Field name is already singular."""
        result = get_singular_type_name("response", "item")
        assert result == "response_item"

    def test_plural_field_name(self):
        """Field name is plural, should be singularized."""
        result = get_singular_type_name("response", "items")
        assert result == "response_item"

    def test_plural_irregular(self):
        """Irregular plural should be handled correctly."""
        result = get_singular_type_name("response", "currencies")
        assert result == "response_currency"

    def test_plural_ending_in_data(self):
        """Words ending in 'data' that are plural."""
        result = get_singular_type_name("response", "metadata")
        # inflect treats metadata as plural → metadatum (singular)
        assert result == "response_metadatum"

    def test_complex_parent_type(self):
        """Parent type name is complex."""
        result = get_singular_type_name("public_get_orders_response_result", "trades")
        assert result == "public_get_orders_response_result_trade"


@pytest.mark.unit
class TestStripFieldName:
    """Test strip_field_name function."""

    def test_no_indentation(self):
        """Field name has no indentation markers."""
        result = strip_field_name("field_name")
        assert result == "field_name"

    def test_single_indentation(self):
        """Field name has single level indentation."""
        result = strip_field_name("› field_name")
        assert result == "field_name"

    def test_double_indentation(self):
        """Field name has double level indentation."""
        result = strip_field_name("› › field_name")
        assert result == "field_name"

    def test_triple_indentation(self):
        """Field name has triple level indentation."""
        result = strip_field_name("› › › field_name")
        # strip_field_name only does literal replacement of '› ' and '› › '
        # After both replacements: "› › › field_name" → "› › field_name" → "› field_name" → "field_name"
        assert result == "field_name"

    def test_mixed_spaces(self):
        """Field name has mixed indentation and spaces."""
        result = strip_field_name("› › my_field")
        assert result == "my_field"


@pytest.mark.unit
class TestCountIdent:
    """Test count_ident function."""

    def test_no_indentation(self):
        """Field name has no indentation."""
        result = count_ident("field_name")
        assert result == 0

    def test_single_indentation(self):
        """Field name has one indentation marker."""
        result = count_ident("› field_name")
        assert result == 1

    def test_double_indentation(self):
        """Field name has two indentation markers."""
        result = count_ident("› › field_name")
        assert result == 2

    def test_triple_indentation(self):
        """Field name has three indentation markers."""
        result = count_ident("› › › field_name")
        assert result == 3

    def test_indentation_only(self):
        """String with only indentation markers."""
        result = count_ident("› › ")
        assert result == 2


@pytest.mark.unit
class TestUrlToTypeName:
    """Test url_to_type_name function."""

    def test_simple_public_endpoint(self):
        """Convert simple public endpoint URL."""
        result = url_to_type_name("/public/get_time")
        assert result == "public_get_time"

    def test_simple_private_endpoint(self):
        """Convert simple private endpoint URL."""
        result = url_to_type_name("/private/get_orders")
        assert result == "private_get_orders"

    def test_nested_endpoint(self):
        """Convert nested endpoint URL."""
        result = url_to_type_name("/public/auth")
        assert result == "public_auth"

    def test_multi_part_endpoint(self):
        """Convert multi-part endpoint URL."""
        result = url_to_type_name("/private/get_order_book")
        assert result == "private_get_order_book"

    def test_leading_slash_only(self):
        """Handle edge case with just leading slash."""
        result = url_to_type_name("/")
        assert result == ""

    def test_endpoint_with_underscores(self):
        """Endpoint already has underscores."""
        result = url_to_type_name("/public/get_index_price_names")
        assert result == "public_get_index_price_names"
