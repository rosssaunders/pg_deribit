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
    fields: List[Field]
    enums: List[Enum]


@dataclass
class Parameter:
    name: str
    type: Type
    comment: str


@dataclass
class Function:
    name: str
    path: str
    is_private: bool
    comment: str
    parameters: List[Parameter]
    response_type: Type


@dataclass
class Endpoint:
    name: str
    request_types: List[Type]
    response_types: List[Type]
    functions: List[Function]
