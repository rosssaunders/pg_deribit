"""
Type pattern handlers for parsing Deribit API documentation.

This module implements the Strategy pattern to handle different type patterns
found in the API documentation (object, array of object, array of string, etc.).
"""

import logging
from abc import ABC, abstractmethod
from typing import Dict, Optional

import inflect

from models.models import Field, TypeDefinition

logger = logging.getLogger(__name__)
p = inflect.engine()


class TypePatternHandler(ABC):
    """Abstract base class for type pattern handlers."""

    @abstractmethod
    def can_handle(self, type_string: str) -> bool:
        """Check if this handler can process the given type string."""
        pass

    @abstractmethod
    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        """
        Handle the type pattern and return (new_current_type, response_type).

        Args:
            field_name: Name of the field
            type_string: Type string from documentation
            comment: Field documentation
            parent_type_name: Name of the parent response type
            types_registry: Registry of all types
            current_type_name: Current type being built

        Returns:
            Tuple of (new_current_type_name, response_type_if_result_field)
            Returns None if no type change needed
        """
        pass


class ObjectTypeHandler(TypePatternHandler):
    """Handles 'object' type - creates a new nested type."""

    def can_handle(self, type_string: str) -> bool:
        return type_string == "object"

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        new_type_name = f"{parent_type_name}_{field_name}"

        # Create and add the field to parent
        field_type = TypeDefinition(new_type_name)
        field_type.is_class = True

        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=field_type, documentation=comment, required=False)
        )
        parent_type = types_registry[current_type_name]

        # Create the new type
        types_registry[new_type_name] = TypeDefinition(new_type_name)
        types_registry[new_type_name].parent = parent_type

        # Check if this is the result field
        response_type = types_registry[new_type_name] if field_name == "result" else None

        return (new_type_name, response_type)


class ArrayOfObjectHandler(TypePatternHandler):
    """Handles 'array of object' type."""

    def can_handle(self, type_string: str) -> bool:
        return type_string == "array of object"

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        # Singularize the type name
        if p.singular_noun(field_name) is False:
            new_type_name = f"{parent_type_name}_{field_name}"
        else:
            new_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

        field_type = TypeDefinition(new_type_name)
        field_type.is_class = True
        field_type.is_array = True

        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=field_type, documentation=comment, required=False)
        )
        parent_type = types_registry[current_type_name]

        types_registry[new_type_name] = TypeDefinition(name=new_type_name)
        types_registry[new_type_name].is_array = True
        types_registry[new_type_name].parent = parent_type

        response_type = types_registry[new_type_name] if field_name == "result" else None

        return (new_type_name, response_type)


class ArrayTypeHandler(TypePatternHandler):
    """Handles generic 'array' type."""

    def can_handle(self, type_string: str) -> bool:
        return type_string == "array"

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        field_type = TypeDefinition("string")
        field_type.is_array = True
        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=field_type, documentation=comment, required=False)
        )

        response_type = None
        if field_name == "result":
            response_type = TypeDefinition(name="string")
            response_type.is_primitive = True
            response_type.is_array = True

        return (current_type_name, response_type)


class ArrayOfPrimitiveHandler(TypePatternHandler):
    """Handles 'array of <primitive>' types (string, number, integer)."""

    PRIMITIVES = {"string", "number", "integer"}

    def can_handle(self, type_string: str) -> bool:
        for primitive in self.PRIMITIVES:
            if type_string == f"array of {primitive}":
                return True
        return False

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        # Extract primitive type
        primitive = type_string.replace("array of ", "")

        field_type = TypeDefinition(primitive)
        field_type.is_array = True
        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=field_type, documentation=comment, required=False)
        )

        response_type = None
        if field_name == "result":
            response_type = TypeDefinition(name="string")
            response_type.is_primitive = True
            response_type.is_array = True

        return (current_type_name, response_type)


class ArrayOfPriceAmountHandler(TypePatternHandler):
    """Handles 'array of [price, amount]' type - nested array."""

    def can_handle(self, type_string: str) -> bool:
        return type_string == "array of [price, amount]"

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        field_type = TypeDefinition("float[]")
        field_type.is_array = True

        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=field_type, documentation=comment, required=False)
        )

        response_type = None
        if field_name == "result":
            response_type = TypeDefinition(name="string")
            response_type.is_primitive = True
            response_type.is_array = True

        return (current_type_name, response_type)


class ArrayOfTimestampValueHandler(TypePatternHandler):
    """Handles 'array of [timestamp, value]' type."""

    def can_handle(self, type_string: str) -> bool:
        return type_string == "array of [timestamp, value]"

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        # Singularize the type name
        if p.singular_noun(field_name) is False:
            new_type_name = f"{parent_type_name}_{field_name}"
        else:
            new_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

        # Create nested array type
        field_type = TypeDefinition("float[]")
        field_type.is_class = True
        field_type.is_array = True

        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=field_type, documentation=comment, required=False)
        )

        # Create the new type
        types_registry[new_type_name] = TypeDefinition(name=new_type_name)
        types_registry[new_type_name].is_array = True
        types_registry[new_type_name].is_nested_array = True

        # Add timestamp and value fields
        types_registry[new_type_name].fields.append(
            Field(name="timestamp", type=TypeDefinition(name="integer"))
        )
        types_registry[new_type_name].fields.append(
            Field(name="value", type=TypeDefinition(name="number"))
        )

        response_type = types_registry[new_type_name] if field_name == "result" else None

        return (new_type_name, response_type)


class ObjectOrStringHandler(TypePatternHandler):
    """Handles 'object or string' type - sum type (treated as string for now)."""

    def can_handle(self, type_string: str) -> bool:
        return type_string == "object or string"

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        # TODO: Properly handle sum types
        field_type = TypeDefinition(name="string")
        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=field_type, documentation=comment, required=False)
        )

        return (current_type_name, None)


class PrimitiveTypeHandler(TypePatternHandler):
    """Handles primitive types (string, number, integer, boolean, text)."""

    def can_handle(self, type_string: str) -> bool:
        # This is the fallback handler - handles everything else as primitive
        return True

    def handle(
        self,
        field_name: str,
        type_string: str,
        comment: str,
        parent_type_name: str,
        types_registry: Dict[str, TypeDefinition],
        current_type_name: str,
    ) -> Optional[tuple[str, Optional[TypeDefinition]]]:
        data_type = type_string
        if data_type == "text":
            data_type = "string"

        # Special case for contract_size (should be number)
        if field_name == "contract_size":
            data_type = "number"

        type_def = TypeDefinition(name=data_type)
        types_registry[current_type_name].fields.append(
            Field(name=field_name, type=type_def, documentation=comment, required=False)
        )

        response_type = None
        if field_name == "result":
            response_type = TypeDefinition(name=data_type)
            response_type.is_primitive = True

        return (current_type_name, response_type)


class TypePatternRegistry:
    """
    Registry that dispatches type patterns to appropriate handlers.

    Uses Chain of Responsibility pattern to find the right handler.
    """

    def __init__(self):
        self.handlers = [
            ObjectTypeHandler(),
            ArrayOfObjectHandler(),
            ArrayOfPrimitiveHandler(),
            ArrayOfPriceAmountHandler(),
            ArrayOfTimestampValueHandler(),
            ObjectOrStringHandler(),
            ArrayTypeHandler(),
            PrimitiveTypeHandler(),  # Fallback handler must be last
        ]

    def get_handler(self, type_string: str) -> TypePatternHandler:
        """Find the first handler that can process this type string."""
        for handler in self.handlers:
            if handler.can_handle(type_string):
                logger.debug(f"Handler {handler.__class__.__name__} selected for '{type_string}'")
                return handler

        # Should never reach here since PrimitiveTypeHandler handles everything
        raise ValueError(f"No handler found for type: {type_string}")
