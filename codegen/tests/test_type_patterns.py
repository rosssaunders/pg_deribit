"""Unit tests for type pattern handlers."""

import pytest

from deribit.type_patterns import (
    ArrayOfObjectHandler,
    ArrayOfPriceAmountHandler,
    ArrayOfPrimitiveHandler,
    ArrayOfTimestampValueHandler,
    ArrayTypeHandler,
    ObjectOrStringHandler,
    ObjectTypeHandler,
    PrimitiveTypeHandler,
    TypePatternRegistry,
)
from models.models import TypeDefinition


@pytest.mark.unit
class TestObjectTypeHandler:
    """Test ObjectTypeHandler."""

    def test_can_handle(self):
        handler = ObjectTypeHandler()
        assert handler.can_handle("object") is True
        assert handler.can_handle("array") is False
        assert handler.can_handle("string") is False

    def test_handle_creates_nested_type(self):
        handler = ObjectTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="data",
            type_string="object",
            comment="Data object",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert new_type == "parent_data"
        assert response_type is None  # Not a result field
        assert "parent_data" in types
        assert types["parent_data"].is_class is False  # Type itself isn't marked as class

    def test_handle_result_field(self):
        handler = ObjectTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="result",
            type_string="object",
            comment="Result",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert response_type is not None
        assert response_type.name == "parent_result"


@pytest.mark.unit
class TestArrayOfObjectHandler:
    """Test ArrayOfObjectHandler."""

    def test_can_handle(self):
        handler = ArrayOfObjectHandler()
        assert handler.can_handle("array of object") is True
        assert handler.can_handle("object") is False
        assert handler.can_handle("array") is False

    def test_handle_creates_array_type(self):
        handler = ArrayOfObjectHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="items",
            type_string="array of object",
            comment="List of items",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert new_type == "parent_item"  # Singularized
        assert "parent_item" in types
        assert types["parent_item"].is_array is True


@pytest.mark.unit
class TestArrayTypeHandler:
    """Test ArrayTypeHandler."""

    def test_can_handle(self):
        handler = ArrayTypeHandler()
        assert handler.can_handle("array") is True
        assert handler.can_handle("array of object") is False

    def test_handle_creates_string_array(self):
        handler = ArrayTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="tags",
            type_string="array",
            comment="Tags",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert new_type == "parent_response"  # No type change
        assert len(types["parent_response"].fields) == 1
        assert types["parent_response"].fields[0].type.is_array is True


@pytest.mark.unit
class TestArrayOfPrimitiveHandler:
    """Test ArrayOfPrimitiveHandler."""

    def test_can_handle(self):
        handler = ArrayOfPrimitiveHandler()
        assert handler.can_handle("array of string") is True
        assert handler.can_handle("array of number") is True
        assert handler.can_handle("array of integer") is True
        assert handler.can_handle("array of object") is False

    def test_handle_array_of_string(self):
        handler = ArrayOfPrimitiveHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="names",
            type_string="array of string",
            comment="Names",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, _ = result
        assert new_type == "parent_response"
        assert len(types["parent_response"].fields) == 1
        assert types["parent_response"].fields[0].type.name == "string"
        assert types["parent_response"].fields[0].type.is_array is True


@pytest.mark.unit
class TestArrayOfPriceAmountHandler:
    """Test ArrayOfPriceAmountHandler."""

    def test_can_handle(self):
        handler = ArrayOfPriceAmountHandler()
        assert handler.can_handle("array of [price, amount]") is True
        assert handler.can_handle("array of object") is False

    def test_handle_creates_nested_array(self):
        handler = ArrayOfPriceAmountHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="bids",
            type_string="array of [price, amount]",
            comment="Bid prices",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, _ = result
        assert new_type == "parent_response"
        assert len(types["parent_response"].fields) == 1
        assert types["parent_response"].fields[0].type.name == "float[]"


@pytest.mark.unit
class TestArrayOfTimestampValueHandler:
    """Test ArrayOfTimestampValueHandler."""

    def test_can_handle(self):
        handler = ArrayOfTimestampValueHandler()
        assert handler.can_handle("array of [timestamp, value]") is True
        assert handler.can_handle("array of [price, amount]") is False

    def test_handle_creates_timestamp_value_type(self):
        handler = ArrayOfTimestampValueHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="ticks",
            type_string="array of [timestamp, value]",
            comment="Tick data",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, _ = result
        assert new_type == "parent_tick"  # Singularized
        assert "parent_tick" in types
        assert types["parent_tick"].is_nested_array is True
        assert len(types["parent_tick"].fields) == 2
        assert types["parent_tick"].fields[0].name == "timestamp"
        assert types["parent_tick"].fields[1].name == "value"


@pytest.mark.unit
class TestObjectOrStringHandler:
    """Test ObjectOrStringHandler."""

    def test_can_handle(self):
        handler = ObjectOrStringHandler()
        assert handler.can_handle("object or string") is True
        assert handler.can_handle("string") is False

    def test_handle_treats_as_string(self):
        handler = ObjectOrStringHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="data",
            type_string="object or string",
            comment="Flexible data",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, _ = result
        assert new_type == "parent_response"
        assert len(types["parent_response"].fields) == 1
        assert types["parent_response"].fields[0].type.name == "string"


@pytest.mark.unit
class TestPrimitiveTypeHandler:
    """Test PrimitiveTypeHandler (fallback)."""

    def test_can_handle_everything(self):
        handler = PrimitiveTypeHandler()
        assert handler.can_handle("string") is True
        assert handler.can_handle("number") is True
        assert handler.can_handle("boolean") is True
        assert handler.can_handle("unknown_type") is True

    def test_handle_string(self):
        handler = PrimitiveTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="name",
            type_string="string",
            comment="Name",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, _ = result
        assert new_type == "parent_response"
        assert len(types["parent_response"].fields) == 1
        assert types["parent_response"].fields[0].type.name == "string"

    def test_handle_text_converts_to_string(self):
        handler = PrimitiveTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="description",
            type_string="text",
            comment="Description",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        assert types["parent_response"].fields[0].type.name == "string"

    def test_handle_contract_size_special_case(self):
        handler = PrimitiveTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="contract_size",
            type_string="string",  # Even if docs say string
            comment="Contract size",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        # contract_size should be converted to number
        assert types["parent_response"].fields[0].type.name == "number"


@pytest.mark.unit
class TestTypePatternRegistry:
    """Test TypePatternRegistry."""

    def test_get_handler_for_object(self):
        registry = TypePatternRegistry()
        handler = registry.get_handler("object")
        assert isinstance(handler, ObjectTypeHandler)

    def test_get_handler_for_array_of_object(self):
        registry = TypePatternRegistry()
        handler = registry.get_handler("array of object")
        assert isinstance(handler, ArrayOfObjectHandler)

    def test_get_handler_for_array_of_string(self):
        registry = TypePatternRegistry()
        handler = registry.get_handler("array of string")
        assert isinstance(handler, ArrayOfPrimitiveHandler)

    def test_get_handler_for_primitive(self):
        registry = TypePatternRegistry()
        handler = registry.get_handler("string")
        assert isinstance(handler, PrimitiveTypeHandler)

    def test_get_handler_for_unknown_falls_back(self):
        registry = TypePatternRegistry()
        handler = registry.get_handler("completely_unknown_type")
        assert isinstance(handler, PrimitiveTypeHandler)

    def test_handler_order_matters(self):
        """Test that more specific handlers are checked before generic ones."""
        registry = TypePatternRegistry()

        # ArrayOfPrimitiveHandler should match before PrimitiveTypeHandler
        handler = registry.get_handler("array of number")
        assert isinstance(handler, ArrayOfPrimitiveHandler)
        assert not isinstance(handler, PrimitiveTypeHandler)


@pytest.mark.unit
class TestArrayOfObjectHandlerEdgeCases:
    """Test edge cases for ArrayOfObjectHandler."""

    def test_handle_singular_field_name(self):
        """Test handling field name that's already singular."""
        handler = ArrayOfObjectHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="data",  # Already singular
            type_string="array of object",
            comment="Data items",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, _ = result
        assert new_type == "parent_datum"  # inflect library converts data -> datum


@pytest.mark.unit
class TestArrayTypeHandlerResultField:
    """Test ArrayTypeHandler with result field."""

    def test_handle_result_field_creates_response_type(self):
        handler = ArrayTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="result",
            type_string="array",
            comment="Result array",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert response_type is not None
        assert response_type.is_primitive is True
        assert response_type.is_array is True


@pytest.mark.unit
class TestArrayOfPrimitiveHandlerResultField:
    """Test ArrayOfPrimitiveHandler with result field."""

    def test_handle_result_field_creates_response_type(self):
        handler = ArrayOfPrimitiveHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="result",
            type_string="array of string",
            comment="Result strings",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert response_type is not None
        assert response_type.is_primitive is True
        assert response_type.is_array is True


@pytest.mark.unit
class TestArrayOfPriceAmountHandlerResultField:
    """Test ArrayOfPriceAmountHandler with result field."""

    def test_handle_result_field_creates_response_type(self):
        handler = ArrayOfPriceAmountHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="result",
            type_string="array of [price, amount]",
            comment="Result prices",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert response_type is not None
        assert response_type.is_primitive is True
        assert response_type.is_array is True


@pytest.mark.unit
class TestArrayOfTimestampValueHandlerSingular:
    """Test ArrayOfTimestampValueHandler with singular field name."""

    def test_handle_singular_field_name(self):
        """Test handling field name that's already singular."""
        handler = ArrayOfTimestampValueHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="data",  # Already singular
            type_string="array of [timestamp, value]",
            comment="Data points",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, _ = result
        assert new_type == "parent_datum"  # inflect library converts data -> datum


@pytest.mark.unit
class TestPrimitiveTypeHandlerResultField:
    """Test PrimitiveTypeHandler with result field."""

    def test_handle_result_field_creates_response_type(self):
        handler = PrimitiveTypeHandler()
        types = {"parent_response": TypeDefinition("parent_response")}

        result = handler.handle(
            field_name="result",
            type_string="string",
            comment="Result",
            parent_type_name="parent",
            types_registry=types,
            current_type_name="parent_response",
        )

        assert result is not None
        new_type, response_type = result
        assert response_type is not None
        assert response_type.is_primitive is True
