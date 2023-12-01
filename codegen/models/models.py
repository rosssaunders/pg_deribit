from __future__ import annotations
from dataclasses import dataclass
from typing import List
from enum import Enum


class TypeName(Enum):
    string = "string"
    double = "float"
    decimal = "decimal"
    integer = "integer"
    boolean = "boolean"
    object = "object"


@dataclass
class Enum:
    type_name: str
    items: List[str]

    def to_dict(self):
        return {
            'name': self.type_name,
            'items': self.items
        }


@dataclass
class FieldType:
    type_name: str
    is_enum: bool = False
    is_class: bool = False
    is_array: bool = False

    def to_dict(self):
        return {
            'type_name': self.type_name,
            'is_enum': self.is_enum,
            'is_class': self.is_class,
            'is_array': self.is_array
        }


@dataclass
class Field:
    name: str
    type: FieldType
    documentation: str = ""
    required: bool = False

    def to_dict(self):
        return {
            'name': self.name,
            'type': self.type.to_dict(),
            'comment': self.documentation,
            'required': self.required
        }


@dataclass
class Type:
    name: str
    fields: List[Field]

    #  this is here as we don't attempt to dedup enums. each type has its own enums if if they are duplicated.
    enums: List[Enum]

    is_array: bool = False
    is_primitive: bool = False

    # If the field is an array of arrays and not an array of objects.
    # If so we need to decompose it differently.
    is_nested_array: bool = False

    # So we can keep track of which parent type will use this type as a field.
    parent: Type = None

    def to_dict(self):
        return {
            'name': self.name,
            'fields': [field.to_dict() for field in self.fields],
            'enums': [enum.to_dict() for enum in self.enums],
            'is_array': self.is_array,
            'is_primitive': self.is_primitive,
            'is_nested_array': self.is_nested_array
        }


@dataclass
class Parameter:
    name: str
    type: Type
    documentation: str = ""

    def to_dict(self):
        return {
            'name': self.name,
            'type': self.type.to_dict(),
            'documentation': self.documentation
        }


@dataclass
class Endpoint:
    name: str
    path: str
    request_type: Type  # The type of the request
    response_type: Type  # The main type to deserialize to
    response_types: List[Type]  # All the types
    rate_limiter: str  # the name of the function to call to rate limit

    def to_dict(self):
        return {
            'name': self.name,
            'path': self.path,
            'request_type': self.request_type.to_dict() if self.request_type is not None else None,
            'response_type': self.response_type.to_dict() if self.response_type is not None else None,
            'response_types': [type.to_dict() for type in self.response_types],
            'rate_limiter': self.rate_limiter
        }


@dataclass
class Function:
    name: str
    endpoint: Endpoint
    comment: str
    response_type: Type

    def to_dict(self):
        return {
            'name': self.name,
            'endpoint': self.endpoint.to_dict(),
            'comment': self.comment,
            'response_type': self.response_type.to_dict()
        }
