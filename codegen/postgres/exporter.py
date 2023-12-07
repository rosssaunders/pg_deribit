import os

from codegen.models.models import Function, Type_, Enum_
from codegen.postgres.enum import enum_to_type
from codegen.postgres.header import header
from codegen.postgres.postgres import invoke_endpoint, type_to_type
from codegen.postgres.tests import test_endpoint


class Exporter:

    def __init__(self):
        self.schema = None
        self.script_dir = os.path.dirname(__file__)

    def set_schema(self, schema: str):
        self.schema = schema

    def setup(self):
        with open(os.path.join(self.script_dir, f"../../test/all_functions.gen.sql"), 'w') as file:
            file.write(header())
            pass
        pass

    @staticmethod
    def sort_functions(functions: [Function]):
        return sorted(functions, key=lambda f: f.endpoint.name)

    def all(self, functions: [Function]):
        self.setup()

        sorted_endpoints = self.sort_functions(functions)

        for function in sorted_endpoints:
            self.export(function)

        # don't treat these as code gens
        with open(os.path.join(self.script_dir, f"../../sql/types/endpoints.sql"), 'w') as file:
            file.write(f"drop type if exists deribit.endpoint cascade;\n\n")
            file.write(f"create type deribit.endpoint as enum (\n")
            file.write(f',\n'.join(f"    '{function.endpoint.path}'" for function in sorted_endpoints))
            file.write(f"\n);\n")

        # don't treat these as code gens
        with open(os.path.join(self.script_dir, f"../../sql/static/endpoints.sql"), 'w') as file:
            file.write(f"""insert into deribit.internal_endpoint_rate_limit (key)\nvalues\n""")
            file.write(f',\n'.join(f"('{function.endpoint.path}')" for function in sorted_endpoints))
            file.write(';\n')

    def export(self, function: Function):
        script_dir = os.path.dirname(__file__)

        with open(os.path.join(script_dir, f"../../sql/types/{function.endpoint.name}.response.gen.sql"), 'w') as file:
            file.write(header())

            for tpe in reversed(function.endpoint.response_types):
                file.write(type_to_type(self.schema, tpe))
                file.write('\n\n')

        if function.endpoint.request_type is not None:
            with open(os.path.join(script_dir, f"../../sql/types/{function.endpoint.name}.request.gen.sql"), 'w') as file:
                file.write(header())

                enums = walk_types_return_enums_in_reverse_order(function.endpoint.request_type)
                for parent, e in enums:
                    file.write(enum_to_type(self.schema, parent.name, e))
                    file.write('\n\n')

                types = walk_types_return_complex_types_in_reverse_order(function.endpoint.request_type)
                for t in types:
                    file.write(type_to_type(self.schema, t))
                    file.write('\n')

        with open(os.path.join(script_dir, f"../../sql/functions/{function.endpoint.name}.gen.sql"), 'w') as file:
            file.write(header())
            file.write(invoke_endpoint(self.schema, function))
            file.write('\n')

        with open(os.path.join(script_dir, f"../../test/all_functions.gen.sql"), 'a') as file:
            file.write(test_endpoint(self.schema, function))
            file.write('\n')


def walk_types_return_enums_in_reverse_order(tpe: Type_) -> [(Type_, Type_)]:
    all_types = walk_types_return_complex_types_in_reverse_order(tpe)
    res = []
    for t in all_types:
        for f in t.fields:
            if f.type.is_enum:
                res.append((t, f.type))

    return res


def walk_types_return_complex_types_in_reverse_order(tpe: Type_) -> [Type_]:
    res = []

    if tpe.is_primitive:
        return res

    for field in tpe.fields:
        if field.type.is_primitive:
            continue

        res.extend(walk_types_return_complex_types_in_reverse_order(field.type))

    res.append(tpe)

    return res