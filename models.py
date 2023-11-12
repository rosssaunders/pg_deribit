from dataclasses import dataclass
from typing import List


@dataclass
class Enum:
    name: str
    items: List[str]


@dataclass
class FieldType:
    name: str
    is_enum: bool
    is_class: bool
    is_array: bool


@dataclass
class Field:
    name: str
    type: FieldType
    comment: str
    required: bool


@dataclass
class Type:
    name: str
    is_primitive: bool
    fields: List[Field]
    enums: List[Enum]
    is_array: bool = False


@dataclass
class Parameter:
    name: str
    type: Type
    comment: str


@dataclass
class Endpoint:
    name: str
    path: str
    request_type: Type  # The type of the request
    response_type: Type  # The main type to deserialize to
    response_types: List[Type]  # All the types


@dataclass
class Function:
    name: str
    endpoint: Endpoint
    # is_private: bool
    comment: str
    # parameters: List[Parameter]
    response_type: Type

