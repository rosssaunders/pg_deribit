"""
Refactored request table parser with better separation of concerns.

This module replaces the procedural request_table_to_type function with
a cleaner class-based architecture.
"""

import logging
from typing import List

import pandas as pd
from pandas import DataFrame

from models.models import EnumDefinition, Field, TypeDefinition
from utils.name_utils import (
    count_ident,
    get_singular_type_name,
    strip_field_name,
    url_to_type_name,
)

logger = logging.getLogger(__name__)


class RequestRow:
    """Represents a row from the request documentation table."""

    def __init__(self, name, required, type_, enum, description):
        self.level = count_ident(name)
        self.name = strip_field_name(name)
        self.required = required
        self.type = type_
        self.enum = enum
        self.description = description

    def is_array(self) -> bool:
        return (
            self.type == "array of objects"
            or self.type == "array"
            or self.type == "string or array of strings"
        )

    def is_primitive(self) -> bool:
        return self.type in {
            "string",
            "text",
            "number",
            "integer",
            "boolean",
            "array",
            "object",
            "string or array of strings",
        }

    def is_enum(self) -> bool:
        return pd.isna(self.enum) is False

    def enum_items(self) -> List[str]:
        return sorted(set(self.enum.split(" ")))

    def to_enum(self) -> EnumDefinition:
        return EnumDefinition(type_name=self.name, items=self.enum_items())

    def to_field_type(self) -> TypeDefinition:
        if self.is_primitive() and self.is_array():
            t = TypeDefinition(name="string")
            t.is_array = True
            t.is_primitive = True
            return t

        if self.is_enum():
            t = TypeDefinition(name=self.name)
            t.is_enum = True
            t.is_primitive = True
            t.enum_items = self.enum_items()
            return t

        t = TypeDefinition(name=self.type)
        t.is_enum = self.is_enum()
        t.is_array = self.is_array()
        t.is_primitive = self.is_primitive()
        return t

    def to_field(self) -> Field:
        return Field(
            name=self.name,
            type=self.to_field_type(),
            required=self.required,
            documentation=self.description,
        )


class ComplexTypeBuilder:
    """Builds complex nested types from request table rows."""

    def __init__(self, parent_name: str):
        self.parent_name = parent_name
        self.name = ""
        self.fields: List[Field] = []
        self.enums: List[EnumDefinition] = []

    def parse(self, row: int, df: DataFrame) -> int:
        """
        Parse a complex type starting from the given row.

        Args:
            row: Starting row index
            df: DataFrame containing the table

        Returns:
            Number of rows consumed by this complex type
        """
        indent_level = 0
        parent_row = self._convert_to_row(df.iloc[row])
        self.name = get_singular_type_name(self.parent_name, parent_row.name)

        rows_consumed = 0
        for j in range(row + 1, len(df)):
            child_row = self._convert_to_row(df.iloc[j])

            if indent_level == 0:
                indent_level = child_row.level
            else:
                if child_row.level < indent_level:
                    break

            if child_row.is_enum():
                self.enums.append(child_row.to_enum())

            self.fields.append(child_row.to_field())
            rows_consumed += 1

        return rows_consumed

    def _convert_to_row(self, df_row) -> RequestRow:
        """Convert a DataFrame row to a RequestRow."""
        return RequestRow(
            name=df_row[0],
            required=df_row[1],
            type_=df_row[2],
            enum=df_row[3],
            description=df_row[4],
        )


class RequestTableParser:
    """
    Parses Deribit API request tables into type definitions.

    This class provides a cleaner, more maintainable architecture for
    parsing request parameter tables.
    """

    def __init__(self):
        self.request_type: TypeDefinition = None
        self.type_name: str = ""

    def parse(self, endpoint: str, table) -> TypeDefinition:
        """
        Parse a request table into a type definition.

        Args:
            endpoint: API endpoint path (e.g., '/public/get_time')
            table: BeautifulSoup table element

        Returns:
            TypeDefinition for the request parameters
        """
        # Parse HTML table to DataFrame
        df = pd.read_html(str(table))[0]

        # Initialize request type
        self.type_name = f"{url_to_type_name(endpoint)}_request"
        self.request_type = TypeDefinition(name=self.type_name)

        # Process each row
        i = 0
        while i < len(df):
            df_row = df.iloc[i]

            # Skip blank rows (incorrect in Deribit docs)
            if pd.isna(df_row[0]):
                i += 1
                continue

            row = self._convert_to_row(df_row)

            # Dispatch to appropriate handler
            if row.is_enum():
                self._handle_enum_field(row)
            elif row.is_array() and row.is_primitive():
                self._handle_primitive_array(row)
            elif row.is_array() and not row.is_primitive():
                rows_consumed = self._handle_complex_array(row, i, df)
                i += rows_consumed
            else:
                self._handle_primitive_field(row)

            i += 1

        return self.request_type

    def _convert_to_row(self, df_row) -> RequestRow:
        """Convert a DataFrame row to a RequestRow."""
        return RequestRow(
            name=df_row[0],
            required=df_row[1],
            type_=df_row[2],
            enum=df_row[3],
            description=df_row[4],
        )

    def _handle_enum_field(self, row: RequestRow):
        """Handle a field with an enumeration."""
        self.request_type.enums.append(row.to_enum())
        self.request_type.fields.append(row.to_field())

    def _handle_primitive_array(self, row: RequestRow):
        """Handle a primitive array field."""
        self.request_type.fields.append(row.to_field())

    def _handle_complex_array(self, row: RequestRow, index: int, df: DataFrame) -> int:
        """
        Handle a complex array field (array of objects).

        Args:
            row: The current row
            index: Current row index
            df: Full DataFrame

        Returns:
            Number of rows consumed by this complex type
        """
        builder = ComplexTypeBuilder(self.type_name)
        rows_consumed = builder.parse(index, df)

        # Create the complex array type
        field_type = TypeDefinition(name=builder.name)
        field_type.is_array = True
        field_type.is_class = True
        field_type.fields = builder.fields
        field_type.enums = builder.enums

        # Create the field
        field = Field(
            name=row.name,
            type=field_type,
            required=row.required,
            documentation=row.description,
        )

        self.request_type.fields.append(field)
        return rows_consumed

    def _handle_primitive_field(self, row: RequestRow):
        """Handle a simple primitive field."""
        self.request_type.fields.append(row.to_field())


def request_table_to_type(endpoint: str, table) -> TypeDefinition:
    """
    Parse a request table into type definitions (new implementation).

    This is a wrapper around RequestTableParser that maintains API compatibility
    with the original function.

    Args:
        endpoint: API endpoint path
        table: BeautifulSoup table element

    Returns:
        TypeDefinition for the request parameters
    """
    parser = RequestTableParser()
    return parser.parse(endpoint, table)
