from __future__ import annotations

from dataclasses import dataclass
from typing import List


@dataclass
class Enum_:
    type_name: str
    items: List[str]

    def to_dict(self):
        return {
            'name': self.type_name,
            'items': self.items
        }


@dataclass
class Field:
    name: str
    type: Type_
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
class Type_:
    def __init__(self, name: str):
        self.name = name
        self.fields: List[Field] = []

        # this is here as we don't attempt to dedup enums. each type has its own enums.
        self.enums: List[Enum_] = []

        self.is_array: bool = False
        self.is_primitive: bool = False
        self.is_enum: bool = False
        self.enum_items: List[str] = []
        self.is_class: bool = False

        # If the field is an array of arrays and not an array of objects.
        # If so we need to decompose it differently.
        self.is_nested_array: bool = False

        # So we can keep track of which parent type will use this type as a field.
        self.parent: Type_ or None = None

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
    type: Type_
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
    request_type: Type_  # The type of the request
    response_type: Type_  # The main type to deserialize to
    response_types: List[Type_]  # All the types
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
    response_type: Type_
    requires_auth: bool

    def to_dict(self):
        return {
            'name': self.name,
            'endpoint': self.endpoint.to_dict(),
            'comment': self.comment,
            'response_type': self.response_type.to_dict() if self.response_type is not None else None,
            'requires_auth': self.requires_auth
        }
