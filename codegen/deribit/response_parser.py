"""
Refactored response table parser with better separation of concerns.

This module replaces the monolithic response_table_to_type function with
a cleaner architecture using the Strategy pattern.
"""

import logging
import warnings
from typing import Dict, List, Optional, Union

import inflect

# Suppress pandas warnings before importing
warnings.simplefilter(action="ignore", category=FutureWarning)
warnings.simplefilter(action="ignore", category=DeprecationWarning)

import pandas as pd  # noqa: E402

from deribit.fix_broken_response_docs import fix_broken_docs  # noqa: E402
from deribit.type_patterns import TypePatternRegistry  # noqa: E402
from models.models import Field, TypeDefinition  # noqa: E402
from utils.name_utils import count_ident, strip_field_name, url_to_type_name  # noqa: E402

logger = logging.getLogger(__name__)
p = inflect.engine()


class ResponseRow:
    """Represents a row from the response documentation table."""

    def __init__(self, name: str, type_: str, description: str):
        self.name = name
        self.type = type_
        self.description = description

    def is_array(self) -> bool:
        return self.type == "array of objects" or self.type == "array"

    def is_primitive(self) -> bool:
        return self.type in {"string", "text", "number", "integer", "boolean", "array"}

    def level(self) -> int:
        """Get the indentation level of this row."""
        return count_ident(self.name)


class ResponseTableParser:
    """
    Parses Deribit API response tables into type definitions.

    This class replaces the monolithic response_table_to_type function
    with a cleaner, more maintainable architecture.
    """

    def __init__(self):
        self.type_registry = TypePatternRegistry()
        self.types: Dict[str, TypeDefinition] = {}
        self.current_type: str = ""
        self.current_indent_level: int = 0
        self.response_type: Optional[TypeDefinition] = None
        self.parent_type_name: str = ""

    def parse(
        self, end_point: str, table
    ) -> tuple[TypeDefinition, TypeDefinition, List[TypeDefinition]]:
        """
        Parse a response table into type definitions.

        Args:
            end_point: API endpoint path (e.g., '/public/get_time')
            table: BeautifulSoup table element

        Returns:
            Tuple of (root_type, response_type, all_types)
        """
        self.parent_type_name = f"{url_to_type_name(end_point)}_response"

        # Parse HTML table to DataFrame
        df = pd.read_html(str(table))[0]

        # Apply documentation fixes
        df = fix_broken_docs(df, end_point)

        # Initialize type registry
        self._initialize_types()

        # Process each row
        index = 0
        while index < len(df):
            row = self._convert_to_row(df.iloc[index])
            index += 1

            if row is None:
                continue

            # Handle indentation changes (moving back to parent types)
            self._handle_indentation(row)

            # Check if 'object' type needs special handling
            if row.type == "object":
                should_handle, index = self._should_handle_object(row, df, index)
                if not should_handle:
                    # Treat as JSON blob
                    row.type = "json"

            # Delegate to pattern handler
            self._handle_type_pattern(row)

        return (
            self.types[self.parent_type_name],
            self.response_type,
            list(self.types.values()),
        )

    def _initialize_types(self):
        """Initialize the type registry with the root response type."""
        self.current_type = self.parent_type_name
        self.types[self.current_type] = TypeDefinition(name=self.current_type)
        self.current_indent_level = 0
        self.response_type = None

    def _convert_to_row(self, df_row) -> Optional[ResponseRow]:
        """Convert a DataFrame row to a ResponseRow."""
        if pd.isna(df_row[0]):
            return None

        name = str(df_row[0])
        type_ = str(df_row[1])
        description = "" if pd.isna(df_row[2]) else str(df_row[2])

        return ResponseRow(name, type_, description)

    def _handle_indentation(self, row: ResponseRow):
        """Handle changes in indentation level (moving back to parent types)."""
        field_indent_level = row.level()

        if field_indent_level < self.current_indent_level:
            # Move back to parent type
            parent = self.types[self.current_type].parent
            if parent:
                self.current_type = parent.name

        self.current_indent_level = field_indent_level

    def _should_handle_object(
        self, row: ResponseRow, df: pd.DataFrame, current_index: int
    ) -> tuple[bool, int]:
        """
        Determine if an 'object' type should create a new type or be treated as JSON.

        Returns:
            Tuple of (should_handle_as_object, next_index)
        """
        # If we're at the end, it's a JSON blob
        if current_index == len(df):
            return (False, current_index)

        # Check if next row is indented (child of this object)
        next_row = self._convert_to_row(df.iloc[current_index])
        field_indent_level = row.level()

        if next_row is not None and next_row.level() == field_indent_level:
            # Next row is at same level, so this is a JSON blob
            return (False, current_index)

        # Next row is indented, so this is a new type
        return (True, current_index)

    def _handle_type_pattern(self, row: ResponseRow):
        """Delegate type handling to the appropriate pattern handler."""
        field_name = strip_field_name(row.name)
        comment = row.description

        # Get the appropriate handler
        handler = self.type_registry.get_handler(row.type)

        # Handle the type
        result = handler.handle(
            field_name=field_name,
            type_string=row.type,
            comment=comment,
            parent_type_name=self.parent_type_name,
            types_registry=self.types,
            current_type_name=self.current_type,
        )

        if result:
            new_type, response_type = result
            self.current_type = new_type
            if response_type:
                self.response_type = response_type


def default_response_type(end_point: str) -> TypeDefinition:
    """
    Create a default response type for endpoints with no response body.

    Args:
        end_point: API endpoint path

    Returns:
        Default TypeDefinition with id and jsonrpc fields
    """
    parent_type_name = f"{url_to_type_name(end_point)}_response"
    def_res_type = TypeDefinition(parent_type_name)
    def_res_type.is_primitive = True

    def_res_type.fields.append(Field(name="id", type=TypeDefinition(name="integer")))
    def_res_type.fields.append(Field(name="jsonrpc", type=TypeDefinition(name="string")))
    return def_res_type


def response_table_to_type(
    end_point: str, table
) -> tuple[TypeDefinition, TypeDefinition, List[TypeDefinition]]:
    """
    Parse a response table into type definitions (new implementation).

    This is a wrapper around ResponseTableParser that maintains API compatibility
    with the original function.

    Args:
        end_point: API endpoint path
        table: BeautifulSoup table element

    Returns:
        Tuple of (root_type, response_type, all_types)
    """
    parser = ResponseTableParser()
    return parser.parse(end_point, table)
