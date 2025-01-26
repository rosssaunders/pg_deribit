from typing import List
import pandas as pd
from pandas import DataFrame

from utils.name_utils import url_to_type_name, get_singular_type_name, count_ident, strip_field_name
from models.models import Type_, Field, Enum_


class request_row:
    def __init__(self, name, required, type_, enum, description):
        self.level = count_ident(name)
        self.name = strip_field_name(name)
        self.required = required
        self.type = type_
        self.enum = enum
        self.description = description

    def is_array(self) -> bool:
        return self.type == 'array of objects' or self.type == 'array' or self.type == 'string or array of strings'

    def is_primitive(self) -> bool:
        return (self.type == 'string' or
                self.type == 'text' or
                self.type == 'number' or
                self.type == 'integer' or
                self.type == 'boolean' or
                self.type == 'array' or
                self.type == 'object' or
                self.type == 'string or array of strings')

    def is_enum(self) -> bool:
        return pd.isna(self.enum) is False

    def enum_items(self) -> List[str]:
        return list(set(self.enum.split(' ')))

    def to_enum(self) -> Enum_:
        return Enum_(type_name=self.name, items=self.enum_items())

    def to_field_type(self) -> Type_:
        if self.is_primitive() and self.is_array():
            t = Type_(name='string')
            t.is_array = True
            t.is_primitive = True
            return t

        if self.is_enum():
            t = Type_(name=self.name)
            t.is_enum = True
            t.is_primitive = True
            t.enum_items = self.enum_items()
            return t

        t = Type_(name=self.type)
        t.is_enum = self.is_enum()
        t.is_array = self.is_array()
        t.is_primitive = self.is_primitive()
        return t

    def to_field(self) -> Field:
        return Field(name=self.name, type=self.to_field_type(), required=self.required, documentation=self.description)


def convert_to_request_row(row):
    name = row[0]
    required = row[1]
    type_ = row[2]
    enum = row[3]
    description = row[4]

    return request_row(name, required, type_, enum, description)


class type_builder:
    def __init__(self, parent_name: str):
        self.parent_name = parent_name
        self.name = ""
        self.fields: List[Field] = []
        self.enums: List[Enum_] = []

    def parse(self, row: int, df: DataFrame):
        indent_level = 0

        parent_row = convert_to_request_row(df.iloc[row])

        self.name = get_singular_type_name(self.parent_name, parent_row.name)

        for j in range(row + 1, len(df)):
            child_row = convert_to_request_row(df.iloc[j])

            if indent_level == 0:
                indent_level = child_row.level
            else:
                if child_row.level < indent_level:
                    break

            if child_row.is_enum():
                self.enums.append(child_row.to_enum())

            self.fields.append(child_row.to_field())


def request_table_to_type(endpoint: str, table) -> Type_:
    df = pd.read_html(str(table), )[0]

    type_name = f"{url_to_type_name(endpoint)}_request"
    request_type = Type_(name=type_name)

    i = 0
    while i < len(df):
        df_row = df.iloc[i]

        # skip blank rows incorrectly in the deribit docs
        # this will be blank if so
        if not pd.isna(df_row[0]):
            
            row = convert_to_request_row(df_row)

            if row.is_enum():
                request_type.enums.append(row.to_enum())
                request_type.fields.append(row.to_field())

            elif row.is_array() and row.is_primitive():
                request_type.fields.append(row.to_field())

            elif row.is_array() and row.is_primitive() is False:
                complex_type_builder = type_builder(type_name)
                complex_type_builder.parse(i, df)

                field_type = Type_(name=complex_type_builder.name)
                field_type.is_array = True
                field_type.is_class = True
                field_type.fields = complex_type_builder.fields
                field_type.enums = complex_type_builder.enums

                field = Field(name=row.name, type=field_type, required=row.required, documentation=row.description)

                request_type.fields.append(field)

                # move the index to the end of the complex type
                i = i + len(complex_type_builder.fields)

            else:
                request_type.fields.append(row.to_field())

        i += 1

    return request_type
