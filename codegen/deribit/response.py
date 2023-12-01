import warnings
import inflect

warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.simplefilter(action='ignore', category=DeprecationWarning)

from typing import List, Dict

import pandas as pd

from codegen.utils.name_utils import url_to_type_name, count_ident, strip_field_name
from codegen.models.models import Type_, Field, Enum_

p = inflect.engine()


class response_row:
    def __init__(self, name, type_, description):
        self.name = name
        self.type = type_
        self.description = description

    def is_array(self) -> bool:
        return self.type == 'array of objects' or self.type == 'array'

    def is_primitive(self) -> bool:
        return (self.type == 'string' or
                self.type == 'text' or
                self.type == 'number' or
                self.type == 'integer' or
                self.type == 'boolean' or
                self.type == 'array')

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
            return t

        if self.is_enum():
            t = Type_(name=self.name)
            t.is_enum = True
            return t

        t = Type_(name=self.type)
        t.is_enum = self.is_enum()
        t.is_array = self.is_array()
        return t

    def to_field(self) -> Field:
        return Field(name=self.name, type=self.to_field_type(), documentation=self.description)

    def level(self):
        return count_ident(self.name)


def convert_to_response_row(row) -> response_row or None:
    if pd.isna(row[0]):
        return None

    name = str(row[0])
    type_ = str(row[1])

    if pd.isna(row[2]):
        description = ''
    else:
        description = str(row[2])

    return response_row(name, type_, description)


def default_response_type(end_point: str) -> Type_:
    parent_type_name = f"{url_to_type_name(end_point)}_response"
    def_res_type = Type_(parent_type_name)
    def_res_type.is_primitive = True

    def_res_type.fields.append(Field(name='id', type=Type_(name='integer')))
    def_res_type.fields.append(Field(name='jsonrpc', type=Type_(name='string')))
    return def_res_type


def response_table_to_type(end_point: str, table) -> (Type_, Type_, List[Type_]):
    parent_type_name = f"{url_to_type_name(end_point)}_response"

    df = pd.read_html(str(table), )[0]

    types: Dict[str, Type_] = dict()

    current_type = parent_type_name

    types[current_type] = Type_(name=current_type)
    root_type = types[current_type]
    response_type: Type_ or None = None
    current_ident_level = 0

    index = 0
    while index < len(df):

        row = convert_to_response_row(df.iloc[index])
        index += 1

        if row is None:
            continue

        field_ident_level = row.level()
        field_name = strip_field_name(row.name)

        if field_ident_level < current_ident_level:
            # change the type back to the parent type
            current_type = types[current_type].parent.name

        current_ident_level = field_ident_level
        comment = row.description

        # hack for tick_size_steps
        if field_name == 'tick_size_steps':
            row.type = 'array of object'

        # hack for underlying_index in the order book... docs incorrect.
        if field_name == 'underlying_index':
            row.type = 'string'

        # if field_name == 'data':
        #     field_name = 'result'

        if row.type == 'object':
            new_type_name = f'{parent_type_name}_{field_name}'

            # Add the field to the parent type
            field_type = Type_(new_type_name)
            field_type.is_class = True

            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))
            parent_type = types[current_type]

            # Create the new type
            current_type = new_type_name
            types[current_type] = Type_(current_type)
            types[current_type].parent = parent_type

            # Check if this is the result field on the response object
            # For Deribit this is the field we return to the caller of the function.
            if field_name == 'result':
                response_type = types[current_type]

            continue

        if row.type == 'array of object':
            if p.singular_noun(field_name) is False:
                new_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            field_type = Type_(new_type_name)
            field_type.is_class = True
            field_type.is_array = True

            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))
            parent_type = types[current_type]

            current_type = new_type_name
            types[current_type] = Type_(name=current_type)
            types[current_type].is_array = True,
            types[current_type].parent = parent_type

            if field_name == 'result':
                response_type = types[current_type]

            continue

        if row.type == 'array':
            field_type = Type_('string')
            field_type.is_array = True
            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type_(name='string')
                response_type.is_primitive = True
                response_type.is_array = True

            continue

        if row.type == 'array of string':
            field_type = Type_('string')
            field_type.is_array = True
            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type_('string')
                response_type.is_primitive = True
                response_type.is_array = True

            continue

        if row.type == 'array of number':
            field_type = Type_('number')
            field_type.is_array = True
            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type_(name='string')
                response_type.is_primitive = True
                response_type.is_array = True

            continue

        if row.type == 'array of integer':
            field_type = Type_('integer')
            field_type.is_array = True
            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type_(name='string')
                response_type.is_primitive = True
                response_type.is_array = True

            continue

        elif row.type == 'array of [price, amount]':
            field_type = Type_('float[]')
            field_type.is_array = True

            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type_(name='string')
                response_type.is_primitive = True
                response_type.is_array = True

            continue

        elif row.type == 'array of [timestamp, value]':
            if p.singular_noun(field_name) is False:
                new_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            # Add the field to the parent type
            field_type = Type_("float[]")
            field_type.is_class = True
            field_type.is_array = True

            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))

            # Create the new type
            current_type = new_type_name
            types[current_type] = Type_(name=current_type)
            types[current_type].is_array=True
            types[current_type].is_nested_array=True

            # Add the fields to the new type
            types[current_type].fields.append(Field(name='timestamp', type=Type_(name='integer')))
            types[current_type].fields.append(Field(name='value', type=Type_(name='number')))

            if field_name == 'result':
                response_type = types[current_type]

            continue

        elif row.type == 'object or string':  # TODO - sum type here
            field_type = Type_(name='string')
            types[current_type].fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False))

        else:
            data_type = row.type
            if data_type == 'text':
                data_type = 'string'

            if field_name == 'contract_size':
                data_type = 'number'

            type_name = Type_(name=data_type)
            types[current_type].fields.append(
                Field(name=field_name, type=type_name, documentation=comment, required=False))

        if field_name == 'result':
            response_type = Type_(name=type_name.name)
            response_type.is_primitive = True

    return root_type, response_type, types.values()
