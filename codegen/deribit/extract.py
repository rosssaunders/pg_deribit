import warnings
import inflect

from codegen.deribit.consts import excluded_urls, matching_engine_endpoints

warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.simplefilter(action='ignore', category=DeprecationWarning)
from typing import Dict, List

import pandas as pd

from codegen.models.models import Endpoint, Enum, Field, FieldType, Function, Type

p = inflect.engine()


def strip_field_name(field_name:str) -> str:
    field_name = str(field_name).replace('› ', '')
    field_name = field_name.replace('› › ', '')
    return field_name


def count_ident(field_name:str) -> int:
    return field_name.count('›')


def url_to_type_name(end_point):
    items = end_point.split('/')
    return '_'.join(items[1:])


def request_table_to_type(endpoint: str, table) -> Type:
    type_name = f"{url_to_type_name(endpoint)}_request"

    df = pd.read_html(str(table), )[0]

    enums: List[Enum] = []
    fields: List[Field] = []
    for index, row in df.iterrows():
        if not pd.isna(row[3]):
            field_type = FieldType(type_name=f"{row[0]}", is_enum=True, is_class=False, is_array=False)
            enum_items = list(set(row[3].split(' ')))
            enums.append(Enum(type_name=field_type.type_name, items=enum_items))
        else:
            field_type = FieldType(type_name=row[2], is_enum=False, is_class=False, is_array=False)
        fields.append(Field(name=row[0], type=field_type, required=row[1], documentation=row[4]))

    return Type(name=f'{type_name}', fields=fields, enums=enums, is_primitive=False)


def response_table_to_type(end_point: str, table) -> (Type, Type, List[Type]):
    parent_type_name = f"{url_to_type_name(end_point)}_response"

    df = pd.read_html(str(table), )[0]

    types: Dict[str, Type] = dict()

    current_type = parent_type_name

    types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False)
    root_type = types[current_type]
    response_type:Type = None
    current_ident_level = 0
    for index, row in df.iterrows():
        if pd.isna(row[0]):
            continue

        field_ident_level = count_ident(str(row[0]))
        field_name = strip_field_name(str(row[0]))

        if field_ident_level < current_ident_level:
            # change the type back to the parent type
            current_type = types[current_type].parent.name

        current_ident_level = field_ident_level

        if pd.isna(row[2]):
            comment = ''
        else:
            comment = str(row[2])

        # hack for tick_size_steps
        if field_name == 'tick_size_steps':
            row[1] = 'array of object'

        # hack for underlying_index in the order book... docs incorrect.
        if field_name == 'underlying_index':
            row[1] = 'string'

        # if field_name == 'data':
        #     field_name = 'result'

        if row[1] == 'object':
            new_type_name = f'{parent_type_name}_{field_name}'

            # Add the field to the parent type
            field_type = FieldType(type_name=new_type_name, is_enum=False, is_class=True, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))
            parent_type = types[current_type]

            # Create the new type
            current_type = new_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False, parent=parent_type)

            # Check if this is the result field on the response object
            # For Deribit this is the field we return to the caller of the function.
            if field_name == 'result':
                response_type = types[current_type]

            continue

        if row[1] == 'array of object':
            if p.singular_noun(field_name) is False:
                new_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            field_type = FieldType(type_name=new_type_name, is_enum=False, is_class=True, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))
            parent_type = types[current_type]

            current_type = new_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False, is_array=True, parent=parent_type)

            if field_name == 'result':
                response_type = types[current_type]

            continue

        if row[1] == 'array':
            field_type = FieldType(type_name='string', is_enum=False, is_class=False, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type(name='string', fields=[], enums=[], is_primitive=True, is_array=True)

            continue

        if row[1] == 'array of string':
            field_type = FieldType(type_name='string', is_enum=False, is_class=False, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type(name='string', fields=[], enums=[], is_primitive=True, is_array=True)

            continue

        if row[1] == 'array of number':
            field_type = FieldType(type_name='number', is_enum=False, is_class=False, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type(name='string', fields=[], enums=[], is_primitive=True, is_array=True)

            continue

        if row[1] == 'array of integer':
            field_type = FieldType(type_name='integer', is_enum=False, is_class=False, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type(name='string', fields=[], enums=[], is_primitive=True, is_array=True)

            continue

        elif row[1] == 'array of [price, amount]':
            field_type = FieldType(type_name='float[]', is_enum=False, is_class=False, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))

            if field_name == 'result':
                response_type = Type(name='string', fields=[], enums=[], is_primitive=True, is_array=True)

            continue

        elif row[1] == 'array of [timestamp, value]':
            if p.singular_noun(field_name) is False:
                new_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            # Add the field to the parent type
            field_type = FieldType(type_name="float[]", is_enum=False, is_class=True, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))

            # Create the new type
            current_type = new_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_array=True, is_nested_array=True)

            # Add the fields to the new type
            types[current_type].fields.append(Field(name='timestamp', type=FieldType(type_name='integer')))
            types[current_type].fields.append(Field(name='value', type=FieldType(type_name='number')))

            if field_name == 'result':
                response_type = types[current_type]

            continue

        elif row[1] == 'object or string':  # TODO - sum type here
            field_type = FieldType(type_name='string', is_enum=False, is_class=False, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=field_type, documentation=comment, required=False))

        else:
            data_type = row[1]
            if data_type == 'text':
                data_type = 'string'

            if field_name == 'contract_size':
                data_type = 'number'

            type_name = FieldType(type_name=data_type, is_enum=False, is_class=False, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=type_name, documentation=comment, required=False))

        if field_name == 'result':
            response_type = Type(name=type_name.type_name, fields=[], enums=[], is_primitive=True)

    return root_type, response_type, types.values()


def extract_function_from_section(sibling):
    file_name = '_'.join(sibling.text.split('/')[1:])

    # check if the url is excluded
    if file_name in excluded_urls:
        print(f'{file_name}: skipping due to {excluded_urls[file_name]}')
        return

    print(f'{file_name}: processing')

    parameters_section = sibling.find_next_sibling('h3', text='Parameters')
    request_type = None
    if parameters_section.nextSibling.nextSibling.text == 'This method takes no parameters':
        print('Method has no parameters')
    else:
        parameters_table = parameters_section.find_next_sibling('table')
        request_type = request_table_to_type(sibling.text, parameters_table)

    response_section = sibling.find_next_sibling('h3', text='Response')
    response_table = response_section.find_next_sibling('table')
    root_type, response_type, all_types = response_table_to_type(sibling.text, response_table)

    rate_limiter = None
    if file_name in matching_engine_endpoints:
        rate_limiter = 'matching_engine_request_log_call'
    else:
        rate_limiter = 'non_matching_engine_request_log_call'

    comment = sibling.find_next_sibling('p')
    function = Function(name=url_to_type_name(sibling.text),
                        endpoint=Endpoint(
                            name=file_name,
                            path=sibling.text,
                            request_type=request_type,
                            response_type=root_type,
                            response_types=all_types,
                            rate_limiter=rate_limiter
                        ),
                        comment=comment.text,
                        response_type=response_type
                        )

    return function
