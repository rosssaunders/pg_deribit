from dataclasses import dataclass
from typing import List


@dataclass
class Enum:
    name: str
    items: List[str]


@dataclass
class FieldType:
    name: str
    is_enum: bool = False
    is_class: bool = False
    is_array: bool = False


@dataclass
class Field:
    name: str
    type: FieldType
    comment: str = ""
    required: bool = False


@dataclass
class Type:
    name: str
    fields: List[Field]
    enums: List[Enum]
    is_array: bool = False
    is_primitive: bool = False
    # If the field is an array of arrays and not an array of objects.
    # If so we need to decompose it differently.
    is_nested_array: bool = False


@dataclass
class Parameter:
    name: str
    type: Type
    comment: str = ""


@dataclass
class Endpoint:
    name: str
    path: str
    request_type: Type  # The type of the request
    response_type: Type  # The main type to deserialize to
    response_types: List[Type]  # All the types
    rate_limiter: str  # the name of the function to call to rate limit


@dataclass
class Function:
    name: str
    endpoint: Endpoint
    comment: str
    response_type: Type

