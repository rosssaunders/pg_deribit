import os
from typing import List

from models.models import Function, Type_
from postgres.enum import enum_to_type
from postgres.header import header
from postgres.postgres import invoke_endpoint, type_to_type


class Exporter:

    def __init__(self):
        self.schema = None
        self.script_dir = os.path.dirname(__file__)

    def set_schema(self, schema: str):
        self.schema = schema

    def setup(self):
        pass

    @staticmethod
    def sort_functions(functions: List[Function]):
        return sorted(functions, key=lambda f: f.endpoint.name)

    def all(self, functions: List[Function]):
        self.setup()

        sorted_endpoints = self.sort_functions(functions)

        for function in sorted_endpoints:
            self.export(function)

        # don't treat these as code gens
        with open(os.path.join(self.script_dir, f"../../sql/types/endpoints.sql"), 'w') as file:
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

        print(f'{function.endpoint.name}: generating')

        with open(os.path.join(script_dir, f"../../sql/endpoints/{function.endpoint.name}.sql"), 'w', encoding='utf-8') as file:
            sections: List[str] = []
            file.write(header())

            if function.endpoint.request_type is not None:
                enums = walk_types_return_enums_in_reverse_order(function.endpoint.request_type)
                for parent, e in enums:
                    sections.append(enum_to_type(self.schema, parent.name, e))

                types = walk_types_return_complex_types_in_reverse_order(function.endpoint.request_type)
                for t in types:
                    sections.append(type_to_type(self.schema, t))

            for tpe in reversed(function.endpoint.response_types):
                sections.append(type_to_type(self.schema, tpe))

            sections.append(invoke_endpoint(self.schema, function))

            file.write("\n\n".join(sections))
            file.write("\n")

        print(f'{function.endpoint.name}: generated')

def walk_types_return_enums_in_reverse_order(tpe: Type_) -> List[tuple[Type_, Type_]]:
    all_types = walk_types_return_complex_types_in_reverse_order(tpe)
    res = []
    for t in all_types:
        for f in t.fields:
            if f.type.is_enum:
                res.append((t, f.type))

    return res


def walk_types_return_complex_types_in_reverse_order(tpe: Type_) -> List[Type_]:
    res: List[Type_] = []

    if tpe.is_primitive:
        return res

    for field in tpe.fields:
        if field.type.is_primitive:
            continue

        res.extend(walk_types_return_complex_types_in_reverse_order(field.type))

    res.append(tpe)

    return res
