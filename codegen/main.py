import json
import sys
import warnings
import os

from deribit.consts import sections
from deribit.extract import extract_function_from_section
from utils.json_utils import CustomJSONizer

warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.simplefilter(action='ignore', category=DeprecationWarning)

from bs4 import BeautifulSoup
from postgres.exporter import Exporter
import requests


deribit_local_url = "deribit.html"
schema = 'deribit'


def download_spec():
    url = "https://docs.deribit.com/"
    response = requests.get(url)
    with open(deribit_local_url, 'w', encoding="utf8") as file:
        file.write(response.text)


def main():
    os.chdir(sys.path[0])

    if not os.path.isfile(deribit_local_url):
        download_spec()
    with open(deribit_local_url, 'r', encoding="utf8") as file:

        documentation = file.read()

    exporter = Exporter()
    exporter.set_schema(schema)

    exporter.setup()

    soup = BeautifulSoup(documentation, "html.parser")

    # dict which contains all the excluded urls
    endpoints = []

    for section in sections:
        h1_tag = soup.find('h1', text=section)

        for sibling in h1_tag.find_next_siblings():
            if sibling.name == 'h1':
                break

            if sibling.name != 'h2':
                continue

            # if sibling.text != '/private/create_combo':
            #     continue

            function = extract_function_from_section(sibling)
            if function is not None:
                endpoints.append(function)

    # export all functions to json
    # Use json.dumps() to convert the object to a JSON string
    endpoint_dict = [endpoint.to_dict() for endpoint in endpoints]
    my_json = json.dumps(endpoint_dict, indent=4, sort_keys=True, cls=CustomJSONizer)

    with open('deribit.json', 'w') as json_file:
        json_file.write(my_json)

    # now codegen the wrapper functions
    exporter.all(endpoints)


if __name__ == '__main__':
    main()
