import inflect
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.simplefilter(action='ignore', category=DeprecationWarning)
import pandas as pd
import requests
from bs4 import BeautifulSoup
from typing import List
from typing import Dict
from exporter import Exporter
from models import Enum, Type, Field, FieldType, Endpoint, Function, Parameter
import os

p = inflect.engine()


def strip_field_name(field_name:str) -> str:
    field_name = str(field_name).replace('› ', '')
    field_name = field_name.replace('› › ', '')
    return field_name


def url_to_type_name(end_point):
    items = end_point.split('/')
    return '_'.join(items[1:])


def request_table_to_type(endpoint: str, table, ep: Endpoint):
    type_name = url_to_type_name(endpoint)

    df = pd.read_html(str(table), )[0]

    enums: List[Enum] = []
    fields: List[Field] = []
    for index, row in df.iterrows():
        if not pd.isna(row[3]):
            field_type = FieldType(name=f"{row[0]}", is_enum=True, is_class=False, is_array=False)
            enum_items = row[3].split(' ')
            enums.append(Enum(name=field_type.name, items=enum_items))
        else:
            field_type = FieldType(name=row[2], is_enum=False, is_class=False, is_array=False)
        fields.append(Field(name=row[0], type=field_type, required=row[1], comment=row[4]))

    ep.request_types.append(Type(name=f'{type_name}_request', fields=fields, enums=enums))


def response_table_to_type(end_point: str, table, ep: Endpoint):
    parent_type_name = url_to_type_name(end_point)

    df = pd.read_html(str(table), )[0]

    types: Dict[str, Type] = dict()

    current_type = f"{parent_type_name}_response"
    previous_type = current_type
    types[current_type] = Type(name=current_type, fields=[], enums=[])
    for index, row in df.iterrows():
        if pd.isna(row[0]):
            continue

        field_name = strip_field_name(str(row[0]))

        if pd.isna(row[2]):
            comment = ''
        else:
            comment = str(row[2])

        if row[1] == 'object':
            new_parent_type_name = f'{parent_type_name}_{field_name}'
            field_type = FieldType(name=new_parent_type_name, is_enum=False, is_class=True, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))
            previous_type = current_type
            current_type = new_parent_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[])
            continue

        if row[1] == 'array of object':
            new_parent_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"
            field_type = FieldType(name=new_parent_type_name, is_enum=False, is_class=True, is_array=True)
            types[previous_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))
            previous_type = current_type
            current_type = new_parent_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[])
            continue

        field_name = strip_field_name(str(row[0]))
        type_name = FieldType(name=row[1], is_enum=False, is_class=False, is_array=False)
        types[current_type].fields.append(Field(name=field_name, type=type_name, comment=comment, required=False))

    for type_name in types.values():
        ep.response_types.append(type_name)


def download_spec():
    url = "https://docs.deribit.com/"
    response = requests.get(url)
    with open(f"deribit.html", 'w') as file:
        file.write(response.text)


def main():
    if not os.path.isfile(f"deribit.html"):
        download_spec()

    with open(f"deribit.html", 'r') as file:
        response = file.read()

    exporter = Exporter()
    exporter.set_schema('deribit')

    exporter.setup()

    soup = BeautifulSoup(response, "html.parser")
    h1_tag = soup.find('h1', text='Trading')

    for sibling in h1_tag.find_next_siblings():
        if sibling.name == 'h1':
            break

        if sibling.name != 'h2':
            continue

        file_name = '/'.join(sibling.text.split('/')[1:])
        print(file_name)

        ep = Endpoint(name=file_name, request_types=[], response_types=[], functions=[])

        arguments = sibling.find_next_sibling('table')
        request_table_to_type(sibling.text, arguments, ep)

        response = arguments.find_next_sibling('table')
        response_table_to_type(sibling.text, response, ep)

        comment = sibling.find_next_sibling('p')
        parent_type_name = url_to_type_name(sibling.text)
        func = Function(
            name=parent_type_name,
            path=sibling.text,
            is_private=True,
            comment=comment.text,
            parameters=[],
            response_type=ep.response_types[0])
        func.parameters.append(Parameter(name='params', type=ep.request_types[0], comment=''))
        ep.functions.append(func)

        # export to a file
        exporter.export(ep)


if __name__ == '__main__':
    main()
