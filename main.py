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


def request_table_to_type(endpoint: str, table) -> Type:
    type_name = f"{url_to_type_name(endpoint)}_request"

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

    return Type(name=f'{type_name}', fields=fields, enums=enums, is_primitive=False)
    # function.endpoint.request_type = Type(name=f'{type_name}', fields=fields, enums=enums)
    # ep.request_types.append(Type(name=f'{type_name}', fields=fields, enums=enums))


def response_table_to_type(end_point: str, table) -> (Type, Type, List[Type]):
    parent_type_name = f"{url_to_type_name(end_point)}_response"

    df = pd.read_html(str(table), )[0]

    types: Dict[str, Type] = dict()

    current_type = parent_type_name
    previous_type = current_type
    types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False)
    root_type = types[current_type]
    result_type = None
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
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False)
            if field_name == 'result':
                result_type = types[current_type]

        elif row[1] == 'array of object':
            if p.singular_noun(field_name) is False:
                new_parent_type_name = f"{parent_type_name}_{field_name}"
            else:
                new_parent_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

            field_type = FieldType(name=new_parent_type_name, is_enum=False, is_class=True, is_array=True)
            types[previous_type].fields.append(Field(name=field_name, type=field_type, comment=comment, required=False))
            previous_type = current_type
            current_type = new_parent_type_name
            types[current_type] = Type(name=current_type, fields=[], enums=[], is_primitive=False)
            if field_name == 'result':
                result_type = types[current_type]

        else:
            type_name = FieldType(name=row[1], is_enum=False, is_class=False, is_array=False)
            types[current_type].fields.append(Field(name=field_name, type=type_name, comment=comment, required=False))

            if field_name == 'result':
                result_type = Type(name=type_name.name, fields=[], enums=[], is_primitive=True)

    return root_type, result_type, types.values()


def download_spec():
    url = "https://docs.deribit.com/"
    response = requests.get(url)
    with open(f"docs/deribit.html", 'w') as file:
        file.write(response.text)


def main():
    if not os.path.isfile(f"docs/deribit.html"):
        download_spec()

    with open(f"docs/deribit.html", 'r') as file:
        response_table = file.read()

    exporter = Exporter()
    exporter.set_schema('deribit')

    exporter.setup()

    soup = BeautifulSoup(response_table, "html.parser")

    sections = ['Account management', 'Trading', 'Wallet']

    for section in sections:

        h1_tag = soup.find('h1', text=section)

        for sibling in h1_tag.find_next_siblings():
            if sibling.name == 'h1':
                break

            if sibling.name != 'h2':
                continue

            file_name = '/'.join(sibling.text.split('/')[1:])
            if file_name == 'private/get_user_trades_by_order':
                print(f'{file_name}: skipping due to invalid documentation')
                continue
            elif file_name == 'public/get_portfolio_margins':
                print(f'{file_name}: skipping due to invalid documentation')
                continue
            else:
                print(f'{file_name}: processing')

            parameters_section = sibling.find_next_sibling('h3', text='Parameters')
            request_type = None
            if parameters_section.nextSibling.nextSibling.name == 'p':
                print('Method has no parameters')
            else:
                parameters_table = parameters_section.find_next_sibling('table')
                request_type = request_table_to_type(sibling.text, parameters_table)

            response_section = sibling.find_next_sibling('h3', text='Response')
            response_table = response_section.find_next_sibling('table')
            root_type, result_type, all_types = response_table_to_type(sibling.text, response_table)

            comment = sibling.find_next_sibling('p')
            function = Function(name=url_to_type_name(sibling.text),
                                endpoint=Endpoint(
                                    name=file_name,
                                    path=sibling.text,
                                    request_type=request_type,
                                    response_type=root_type,
                                    response_types=all_types),
                                comment=comment.text,
                                response_type=result_type
                                )

            # export to a file
            exporter.export(function)


if __name__ == '__main__':
    main()
