import os
from models import Endpoint
from postgres import enum_to_type, type_to_type, invoke_endpoint


class Exporter:

    def __init__(self):
        self.schema = None

    def set_schema(self, schema: str):
        self.schema = schema

    def setup(self):
        os.makedirs(f"{self.schema}", exist_ok=True)
        os.makedirs(f"{self.schema}/private", exist_ok=True)
        os.makedirs(f"{self.schema}/public", exist_ok=True)

    def export(self, end_point: Endpoint):

        with open(f"{self.schema}/{end_point.name}.sql", 'w') as file:

            for tpe in reversed(end_point.response_types):
                file.write(type_to_type(self.schema, tpe))
                file.write('\n\n')

            for tpe in end_point.request_types:
                for enum in tpe.enums:
                    file.write(enum_to_type(self.schema, tpe.name, enum))
                    file.write('\n\n')

                file.write(type_to_type(self.schema, tpe))
                file.write('\n\n')

            for fun in end_point.functions:
                file.write(invoke_endpoint(self.schema, fun.parameters[0].type, fun))
                file.write('\n\n')
