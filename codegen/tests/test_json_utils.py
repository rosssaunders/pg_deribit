"""Unit tests for JSON utility functions."""

import json
import numpy as np
import pytest
from utils.json_utils import CustomJSONizer


@pytest.mark.unit
class TestCustomJSONizer:
    """Test CustomJSONizer class."""

    def test_encode_numpy_bool_true(self):
        """Test encoding numpy boolean True."""
        data = {"value": np.bool_(True)}
        result = json.dumps(data, cls=CustomJSONizer)
        # CustomJSONizer encodes numpy bool as string "true"
        assert result == '{"value": "true"}'

    def test_encode_numpy_bool_false(self):
        """Test encoding numpy boolean False."""
        data = {"value": np.bool_(False)}
        result = json.dumps(data, cls=CustomJSONizer)
        # CustomJSONizer encodes numpy bool as string "false"
        assert result == '{"value": "false"}'

    def test_encode_regular_bool(self):
        """Test encoding regular Python boolean."""
        data = {"value": True}
        result = json.dumps(data, cls=CustomJSONizer)
        assert result == '{"value": true}'

    def test_encode_mixed_types(self):
        """Test encoding mixed data types."""
        data = {
            "np_bool": np.bool_(True),
            "py_bool": False,
            "string": "test",
            "number": 42,
            "float": 3.14,
        }
        result = json.dumps(data, cls=CustomJSONizer)
        parsed = json.loads(result)

        # numpy bool becomes string "true", not JSON boolean
        assert parsed["np_bool"] == "true"
        assert parsed["py_bool"] is False
        assert parsed["string"] == "test"
        assert parsed["number"] == 42
        assert parsed["float"] == 3.14

    def test_encode_nested_structure(self):
        """Test encoding nested data structures with numpy bools."""
        data = {
            "outer": {"inner": {"value": np.bool_(True)}},
            "array": [np.bool_(False), np.bool_(True)],
        }
        result = json.dumps(data, cls=CustomJSONizer)
        parsed = json.loads(result)

        # numpy bools become strings
        assert parsed["outer"]["inner"]["value"] == "true"
        assert parsed["array"] == ["false", "true"]

    def test_encode_invalid_type_raises(self):
        """Test that invalid types still raise TypeError."""
        data = {"value": object()}
        with pytest.raises(TypeError):
            json.dumps(data, cls=CustomJSONizer)
