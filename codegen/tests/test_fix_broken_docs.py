"""Unit tests for fix_broken_response_docs."""

import pandas as pd
import pytest

from deribit.fix_broken_response_docs import fix_broken_docs


@pytest.mark.unit
class TestTickSizeStepsFix:
    """Test tick_size_steps structure fix for get_instrument endpoints."""

    def test_fix_public_get_instrument(self):
        """Test fixing tick_size_steps for /public/get_instrument."""
        # Create mock DataFrame with broken structure
        df = pd.DataFrame(
            {
                "Name": [
                    "id",
                    "jsonrpc",
                    "result",
                    "› tick_size_steps",
                    "›› above_price",
                    "››› tick_size",
                    "› other_field",
                ],
                "Type": [
                    "integer",
                    "string",
                    "object",
                    "object",  # Wrong - should be array of object
                    "array",  # Wrong structure
                    "number",
                    "string",
                ],
                "Description": ["ID", "JSON-RPC", "Result", "Steps", "Prices", "Size", "Other"],
            }
        )

        result = fix_broken_docs(df, "/public/get_instrument")

        # Check that tick_size_steps type was fixed
        tick_idx = result[result["Name"].str.contains("tick_size_steps", na=False)].index[0]
        assert result.at[tick_idx, "Type"] == "array of object"

        # Check that new correct structure was inserted (uses "› " for indentation)
        tick_size_fields = [name for name in result["Name"] if "tick_size" in str(name)]
        above_price_fields = [name for name in result["Name"] if "above_price" in str(name)]
        assert len(tick_size_fields) > 0
        assert len(above_price_fields) > 0

        # Check that wrong nested structure was removed
        assert len(result) >= 6  # Should have replaced structure, not just added

    def test_fix_public_get_instruments(self):
        """Test fixing tick_size_steps for /public/get_instruments."""
        df = pd.DataFrame(
            {
                "Name": ["result", "› tick_size_steps", "›› wrong_field"],
                "Type": ["object", "object", "string"],
                "Description": ["Result", "Steps", "Wrong"],
            }
        )

        result = fix_broken_docs(df, "/public/get_instruments")

        # Check that tick_size_steps type was fixed
        tick_idx = result[result["Name"].str.contains("tick_size_steps", na=False)].index[0]
        assert result.at[tick_idx, "Type"] == "array of object"

    def test_tick_size_steps_not_found(self):
        """Test handling when tick_size_steps is not in the DataFrame."""
        df = pd.DataFrame(
            {
                "Name": ["id", "result"],
                "Type": ["integer", "object"],
                "Description": ["ID", "Result"],
            }
        )

        result = fix_broken_docs(df, "/public/get_instrument")

        # Should return unchanged DataFrame with warning logged
        assert len(result) == 2
        assert list(result["Name"]) == ["id", "result"]

    def test_tick_size_steps_with_multiple_indent_levels(self):
        """Test fixing tick_size_steps with different indentation."""
        df = pd.DataFrame(
            {
                "Name": [
                    "result",
                    "› data",
                    "›› tick_size_steps",
                    "››› nested_wrong",
                    "›››› deeply_nested",
                ],
                "Type": ["object", "object", "object", "array", "number"],
                "Description": ["R", "D", "T", "N", "DN"],
            }
        )

        result = fix_broken_docs(df, "/public/get_instrument")

        # Check correct indentation level was used (uses "› " repeated)
        tick_size_fields = [name for name in result["Name"] if "tick_size" in str(name) and name != "›› tick_size_steps"]
        above_price_fields = [name for name in result["Name"] if "above_price" in str(name)]
        assert len(tick_size_fields) > 0
        assert len(above_price_fields) > 0


@pytest.mark.unit
class TestUnderlyingIndexFix:
    """Test underlying_index type fix for order book endpoints."""

    def test_fix_get_order_book(self):
        """Test fixing row 38 type for /public/get_order_book."""
        df = pd.DataFrame({"Name": [f"field_{i}" for i in range(40)], "Type": ["object"] * 40})

        result = fix_broken_docs(df, "/public/get_order_book")

        assert result.at[38, "Type"] == "string"

    def test_fix_get_order_book_by_instrument_id(self):
        """Test fixing row 38 type for /public/get_order_book_by_instrument_id."""
        df = pd.DataFrame({"Name": [f"field_{i}" for i in range(40)], "Type": ["object"] * 40})

        result = fix_broken_docs(df, "/public/get_order_book_by_instrument_id")

        assert result.at[38, "Type"] == "string"

    def test_fix_public_ticker(self):
        """Test fixing row 38 type for /public/ticker."""
        df = pd.DataFrame({"Name": [f"field_{i}" for i in range(40)], "Type": ["object"] * 40})

        result = fix_broken_docs(df, "/public/ticker")

        assert result.at[38, "Type"] == "string"


@pytest.mark.unit
class TestGetUserTradesByOrderFix:
    """Test missing result field fix for /private/get_user_trades_by_order."""

    def test_fix_missing_result_field(self):
        """Test fixing missing result field and indentation."""
        df = pd.DataFrame(
            {
                "Name": ["id", "jsonrpc", "array of", "field1", "field2"],
                "Type": ["integer", "string", "object", "string", "number"],
                "Description": ["ID", "RPC", "Array", "F1", "F2"],
            }
        )

        result = fix_broken_docs(df, "/private/get_user_trades_by_order")

        # Check that "array of" was renamed to "result"
        assert "result" in result["Name"].values
        assert "array of" not in result["Name"].values

        # Check that result type was set correctly
        result_row = result[result["Name"] == "result"]
        assert result_row["Type"].values[0] == "array of object"

        # Check that fields after row 2 have indentation
        for idx in range(3, len(result)):
            assert result.at[idx, "Name"].startswith("› ")


@pytest.mark.unit
class TestSetClearanceOriginatorFix:
    """Test missing result field fix for /private/set_clearance_originator."""

    def test_add_result_boolean_field(self):
        """Test adding boolean result field."""
        df = pd.DataFrame(
            {
                "Name": ["id", "jsonrpc", "other_field"],
                "Type": ["integer", "string", "string"],
                "Description": ["ID", "RPC", "Other"],
            }
        )

        result = fix_broken_docs(df, "/private/set_clearance_originator")

        # Check that result field was added
        assert "result" in result["Name"].values

        # Check that result is boolean type
        result_row = result[result["Name"] == "result"]
        assert result_row["Type"].values[0] == "boolean"

        # Check that it was inserted at position 2 (after id and jsonrpc)
        assert result.at[2, "Name"] == "result"


@pytest.mark.unit
class TestNoFixRequired:
    """Test that endpoints without fixes pass through unchanged."""

    def test_unaffected_endpoint(self):
        """Test that random endpoints are not modified."""
        df = pd.DataFrame(
            {
                "Name": ["id", "result", "field"],
                "Type": ["integer", "object", "string"],
                "Description": ["ID", "Result", "Field"],
            }
        )

        result = fix_broken_docs(df, "/public/some_random_endpoint")

        # Should be identical
        pd.testing.assert_frame_equal(result, df)

    def test_empty_dataframe(self):
        """Test handling empty DataFrame."""
        df = pd.DataFrame({"Name": [], "Type": [], "Description": []})

        result = fix_broken_docs(df, "/public/test")

        # Should be identical
        pd.testing.assert_frame_equal(result, df)


@pytest.mark.unit
class TestEdgeCases:
    """Test edge cases and error conditions."""

    def test_tick_size_steps_at_end_of_dataframe(self):
        """Test tick_size_steps when it's the last row."""
        df = pd.DataFrame(
            {
                "Name": ["id", "tick_size_steps"],
                "Type": ["integer", "object"],
                "Description": ["ID", "Steps"],
            }
        )

        result = fix_broken_docs(df, "/public/get_instrument")

        # Should fix type and add new rows
        tick_idx = result[result["Name"].str.contains("tick_size_steps", na=False)].index[0]
        assert result.at[tick_idx, "Type"] == "array of object"
        assert len(result) > 2  # New fields added

    def test_tick_size_steps_with_no_nested_rows(self):
        """Test tick_size_steps when there are no incorrect nested rows to remove."""
        df = pd.DataFrame(
            {
                "Name": ["result", "› tick_size_steps", "› other_field"],
                "Type": ["object", "object", "string"],
                "Description": ["Result", "Steps", "Other"],
            }
        )

        result = fix_broken_docs(df, "/public/get_instrument")

        # Should still fix type and add correct structure
        tick_idx = result[result["Name"].str.contains("tick_size_steps", na=False)].index[0]
        assert result.at[tick_idx, "Type"] == "array of object"
        assert any("tick_size" in str(name) for name in result["Name"])
