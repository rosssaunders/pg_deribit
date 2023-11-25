import warnings

import inflect

from codegen.consts import excluded_urls, matching_engine_endpoints, sections

warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.simplefilter(action='ignore', category=DeprecationWarning)
import os
from typing import Dict, List

import pandas as pd
import requests
from bs4 import BeautifulSoup
from exporter import Exporter
from models import Endpoint, Enum, Field, FieldType, Function, Parameter, Type

p = inflect.engine()


def strip_field_name(field_name:str) -> str:
    field_name = str(field_name).replace('› ', '')
    field_name = field_name.replace('› › ', '')
    return field_name


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
            field_type = FieldType(name=f"{row[0]}", is_enum=True, is_class=False, is_array=False)
            enum_items = list(set(row[3].split(' ')))
            enums.append(Enum(name=field_type.name, items=enum_items))
        else:
            field_type = FieldType(name=row[2], is_enum=False, is_class=False, is_array=False)
        fields.append(Field(name=row[0], type=field_type, required=row[1], comment=row[4]))

    return Type(name=f'{type_name}', fields=fields, enums=enums, is_primitive=False)


def response_table_to_type(end_point: str, table) -> (Type, Type, List[Type]):
    parent_type_name = f"{url_to_type_name(end_point)}_response"

    df = pd.read_html(str(table), )[0]

    types: Dict[str, Type] = dict()

    current_type = parent_type_name

    types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False)
    root_type = types[current_type]
    response_type:Type = None
    for index, row in df.iterrows():
        if pd.isna(row[0]):
            continue

        field_name = strip_field_name(str(row[0]))

        if pd.isna(row[2]):
            comment = ''
        else:
            comment = str(row[2])

        # hack for tick_size_steps
        if field_name == 'tick_size_steps':
            row[1] = 'array of object'

        if row[1] == 'object':
            new_parent_type_name = f'{parent_type_name}_{field_name}'
            field_type = FieldType(name=new_parent_type_name, is_enum=False, is_class=True, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))

            current_type = new_parent_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False)

            if field_name == 'result':
                response_type = types[current_type]

            continue

        if row[1] == 'array of object' or row[1] == 'array':
            if p.singular_noun(field_name) is False:
                new_parent_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_parent_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            field_type = FieldType(name=new_parent_type_name, is_enum=False, is_class=True, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))

            current_type = new_parent_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False, is_array=True)

            if field_name == 'result':
                response_type = types[current_type]

            continue

        if row[1] == 'array of string':
            field_type = FieldType(name='string', is_enum=False, is_class=False, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))

            if field_name == 'result':
                response_type = Type(name='string', fields=[], enums=[], is_primitive=True, is_array=True)

            continue

        elif row[1] == 'array of [price, amount]':
            if p.singular_noun(field_name) is False:
                new_parent_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_parent_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            field_type = FieldType(name=new_parent_type_name, is_enum=False, is_class=True, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))

            current_type = new_parent_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False, is_array=True)

            if field_name == 'result':
                response_type = types[current_type]

            continue

        elif row[1] == 'array of [timestamp, value]':
            if p.singular_noun(field_name) is False:
                new_parent_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_parent_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            # Add the field to the parent type
            field_type = FieldType(name=new_parent_type_name, is_enum=False, is_class=True, is_array=True)
            types[current_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))

            # Create the new type
            current_type = new_parent_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_array=True)

            # Add the fields to the new type
            types[current_type].fields.append(Field(name='timestamp', type=FieldType(name='timestamp')))
            types[current_type].fields.append(Field(name='value', type=FieldType(name='number')))

            if field_name == 'result':
                response_type = types[current_type]

            continue

        elif row[1] == 'object or string':  # TODO - sum type here
            field_type = FieldType(name='string', is_enum=False, is_class=False, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))

        else:
            data_type = row[1]
            if data_type == 'text':
                data_type = 'string'

            #if end_point == '/public/get_contract_size':
            if field_name == 'contract_size':
                data_type = 'number'

            type_name = FieldType(name=data_type, is_enum=False, is_class=False, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=type_name, comment=comment, required=False))

        if field_name == 'result':
            response_type = Type(name=type_name.name, fields=[], enums=[], is_primitive=True)

    return root_type, response_type, types.values()


def download_spec():
    url = "https://docs.deribit.com/"
    response = requests.get(url)
    with open(f"docs/deribit.html", 'w') as file:
        file.write(response.text)


def extract_function_from_section(sibling):
    file_name = '_'.join(sibling.text.split('/')[1:])

    # check if the url is excluded
    if file_name in excluded_urls:
        print(f'{file_name}: skipping due to {excluded_urls[file_name]}')
        return

    print(f'{file_name}: processing')

    # if file_name != 'public_get_index_price_names':
    #     continue

    parameters_section = sibling.find_next_sibling('h3', text='Parameters')
    request_type = None
    if parameters_section.nextSibling.nextSibling.name == 'p':
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
    elif file_name.startswith('private'):
        rate_limiter = 'private_request_log_call'
    else:
        rate_limiter = 'public_request_log_call'

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


def main():
    if not os.path.isfile(f"docs/deribit.html"):
        download_spec()

    with open(f"docs/deribit.html", 'r') as file:
        response_table = file.read()

    exporter = Exporter()
    exporter.set_schema('deribit')

    exporter.setup()

    soup = BeautifulSoup(response_table, "html.parser")

    # dict which contains all the excluded urls
    functions = []

    for section in sections:
        h1_tag = soup.find('h1', text=section)

        for sibling in h1_tag.find_next_siblings():
            if sibling.name == 'h1':
                break

            if sibling.name != 'h2':
                continue

            function = extract_function_from_section(sibling)
            if function is not None:
                functions.append(function)

    exporter.all(functions)


if __name__ == '__main__':
    main()
