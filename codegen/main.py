import json
import warnings

import inflect

from codegen.deribit.consts import sections
from codegen.deribit.extract import extract_function_from_section

warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.simplefilter(action='ignore', category=DeprecationWarning)
import os

from bs4 import BeautifulSoup
from codegen.postgres.exporter import Exporter
import requests

p = inflect.engine()


deribit_local_url = "codegen/deribit/deribit.html"
schema = 'deribit'

def download_spec():
    url = "https://docs.deribit.com/"
    response = requests.get(url)
    with open(deribit_local_url, 'w') as file:
        file.write(response.text)




def main():
    if not os.path.isfile(deribit_local_url):
        download_spec()

    with open(deribit_local_url, 'r') as file:
        response_table = file.read()

    exporter = Exporter()
    exporter.set_schema(schema)

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

    # export all functions to json
    # Use json.dumps() to convert the object to a JSON string
    functions_dict = [function.to_dict() for function in functions]
    my_json = json.dumps(functions_dict, indent=4, sort_keys=True)

    # Now you can save this JSON string to a file
    with open('codegen/deribit/deribit.html.json', 'w') as json_file:
        json_file.write(my_json)

    # now codegen the wrapper functions
    exporter.all(functions)


if __name__ == '__main__':
    main()
