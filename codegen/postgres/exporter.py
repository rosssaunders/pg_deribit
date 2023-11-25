import os

from codegen.models.models import Function
from codegen.postgres.postgres import invoke_endpoint, type_to_type
from codegen.postgres.enum import enum_to_type
from codegen.postgres.tests import test_endpoint


class Exporter:

    def __init__(self):
        self.schema = None
        self.script_dir = os.path.dirname(__file__)

    def set_schema(self, schema: str):
        self.schema = schema

    def setup(self):
        with open(os.path.join(self.script_dir, f"../../test/all_functions.sql"), 'w') as file:
            pass
        pass

    def all(self, functions: [Function]):
        self.setup()

        for function in functions:
            self.export(function)

        with open(os.path.join(self.script_dir, f"../../sql/types/endpoints.sql"), 'w') as file:
            file.write(f"drop type if exists deribit.endpoint cascade;\n")
            file.write(f"create type deribit.endpoint as enum (\n")
            file.write(f',\n'.join(f"\t'{function.endpoint.path}'" for function in functions))
            file.write(f"\n);")

        with open(os.path.join(self.script_dir, f"../../sql/static/endpoints.sql"), 'w') as file:
            file.write(f"""insert into deribit.internal_endpoint_rate_limit (key)\nvalues\n""")
            file.write(f',\n'.join(f"\t('{function.endpoint.path}')" for function in functions))
            file.write(';\n')

    def export(self, function: Function):
        script_dir = os.path.dirname(__file__)

        with open(os.path.join(script_dir, f"../../sql/types/{function.endpoint.name}.sql"), 'w') as file:

            for tpe in reversed(function.endpoint.response_types):
                file.write(type_to_type(self.schema, tpe))
                file.write('\n\n')

            if function.endpoint.request_type is not None:
                for enum in function.endpoint.request_type.enums:
                    file.write(enum_to_type(self.schema, function.endpoint.request_type.name, enum))
                    file.write('\n\n')

                file.write(type_to_type(self.schema, function.endpoint.request_type))
                file.write('\n\n')

        with open(os.path.join(script_dir, f"../../sql/functions/{function.endpoint.name}.sql"), 'w') as file:
            file.write(invoke_endpoint(self.schema, function))
            file.write('\n\n')

        with open(os.path.join(script_dir, f"../../test/all_functions.sql"), 'a') as file:
            file.write(test_endpoint(self.schema, function))
            file.write('\n\n')
