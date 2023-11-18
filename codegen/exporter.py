import os
from models import Function
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

    def export(self, function: Function):

        with open(f"{self.schema}/{function.endpoint.name}.sql", 'w') as file:

            file.write(f"""insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('{function.endpoint.name}', null, 0, '0 secs'::interval)
on conflict do nothing;""")
            file.write('\n\n')

            for tpe in reversed(function.endpoint.response_types):
                file.write(type_to_type(self.schema, tpe))
                file.write('\n\n')

            if function.endpoint.request_type is not None:
                for enum in function.endpoint.request_type.enums:
                    file.write(enum_to_type(self.schema, function.endpoint.request_type.name, enum))
                    file.write('\n\n')

                file.write(type_to_type(self.schema, function.endpoint.request_type))
                file.write('\n\n')

            file.write(invoke_endpoint(self.schema, function))
            file.write('\n\n')

