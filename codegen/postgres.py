# converts from the documented type to the postgres type
from models import Enum, Field, FieldType, Function, Type


def escape_postgres_keyword(keyword):
    # List of PostgreSQL reserved keywords
    reserved_keywords = [
        'all', 'analyse', 'analyze', 'and', 'any', 'array', 'as', 'asc', 'asymmetric',
        'both', 'case', 'cast', 'check', 'collate', 'column', 'constraint', 'create',
        'current_date', 'current_role', 'current_time', 'current_timestamp',
        'current_user', 'default', 'deferrable', 'desc', 'distinct', 'do', 'else', 'end',
        'except', 'false', 'for', 'foreign', 'from', 'grant', 'group', 'having', 'in',
        'initially', 'intersect', 'into', 'leading', 'limit', 'localtime', 'localtimestamp',
        'new', 'not', 'null', 'of', 'off', 'offset', 'old', 'on', 'only', 'or', 'order',
        'placing', 'primary', 'references', 'returning', 'select', 'session_user',
        'some', 'symmetric', 'table', 'then', 'to', 'trailing', 'true', 'union', 'unique',
        'user', 'using', 'variadic', 'when', 'where', 'window', 'with', 'interval'
    ]

    # If the keyword is a reserved keyword, return it wrapped in double quotes
    if keyword.lower() in reserved_keywords:
        return f'"{keyword}"'

    # If the keyword is not a reserved keyword, return it as is
    return keyword


def required_to_string(required: bool) -> str:
    if required:
        return '(Required) '
    else:
        return ''


def convert_type_postgres(schema: str, parent_type: str, field_type: FieldType) -> str:
    if field_type.is_array:
        data_type = convert_type_postgres(
            schema,
            parent_type,
            FieldType(name=field_type.name, is_array=False, is_class=field_type.is_class, is_enum=field_type.is_enum)
        )
        return f"{data_type}[]"
    elif field_type.is_enum:
        return f"{schema}.{parent_type}_{field_type.name}"
    elif field_type.is_class:
        return f"{schema}.{field_type.name}"
    elif field_type.name == 'number or string':
        return 'text'
    elif field_type.name == 'string':
        return 'text'
    elif field_type.name == 'text':
        return 'text'
    elif field_type.name == 'float':
        return 'float'
    elif field_type.name == 'number':
        return 'float'
    elif field_type.name == 'decimal':
        return 'numeric'
    elif field_type.name == 'integer':
        return 'bigint'
    elif field_type.name == 'boolean':
        return 'boolean'
    elif field_type.name == 'object':
        return 'jsonb'
    elif field_type.name == 'timestamp':
        return 'timestamp'
    else:
        return f"UNKNOWN - {field_type.name}"


def escape_comment(comment: str) -> str:
    return str(comment).replace("'", "''")


def enum_to_type(schema: str, parent_type: str, enum: Enum) -> str:
    res = f"drop type if exists {schema}.{parent_type}_{enum.name} cascade;\n"
    enums = ', '.join(f'\'{e}\'' for e in enum.items)
    res += f"create type {schema}.{parent_type}_{enum.name} as enum ({enums});"
    return res

def type_to_type(schema: str, type: Type) -> str:
    res = f"drop type if exists {schema}.{type.name} cascade;\n"
    res += f"create type {schema}.{type.name} as (\n"
    res += ',\n'.join(f'\t{escape_postgres_keyword(e.name)} {convert_type_postgres(schema, type.name, e.type)}' for e in type.fields)
    res += f"\n);\n"

    res += '\n'.join(f'comment on column {schema}.{type.name}.{escape_postgres_keyword(e.name)} is \'{required_to_string(e.required)}{escape_comment(e.comment)}\';' for e in type.fields if e.comment != '')

    return res


def default_to_null(field: Field) -> str:
    if field.required:
        return ''
    else:
        return ' default null'


def invoke_endpoint(schema: str, function: Function) -> str:
    res = f"""drop function if exists {schema}.{function.name};\n"""
    res += f"""create or replace function {schema}.{function.name}("""
    if function.endpoint.request_type is not None:
        res += "\n"
        res += ',\n'.join(f'\t{escape_postgres_keyword(f.name)} {convert_type_postgres(schema, function.endpoint.request_type.name, f.type)}{default_to_null(f)}' for f in function.endpoint.request_type.fields)
        res += "\n"
    res += f""")"""

    ######################
    # start return type
    ######################
    if function.response_type.is_array and function.response_type.is_primitive:
        res += f"""
returns setof {convert_type_postgres(schema, function.response_type.name, FieldType(name=function.response_type.name))}
"""

    elif function.response_type.is_array and not function.response_type.is_primitive:
        res += f"""
returns setof {schema}.{function.response_type.name}"""

    elif function.response_type.is_primitive:
        res += f"""
returns {convert_type_postgres(schema, function.response_type.name, FieldType(name=function.response_type.name))}"""

    else:
        res += f"""
returns {schema}.{function.response_type.name}"""

    ######################
    # end return type
    ######################

    res += """
language plpgsql
as $$
declare"""
    if function.endpoint.request_type is not None:
        res += f"\n\t_request {schema}.{function.endpoint.request_type.name};"

    res += """
    _http_response omni_httpc.http_response;
begin
    """

    # invoke the rate limiter
    res += f"""
    perform deribit.matching_engine_request_log_call('{function.endpoint.path}');
    
"""

    if function.endpoint.request_type is not None:
        res += """_request := row(
"""
        res += ',\n'.join(f'\t\t{escape_postgres_keyword(e.name)}' for e in function.endpoint.request_type.fields)
        res += f"""
    )::{schema}.{function.endpoint.request_type.name};
    
    _http_response := deribit.internal_jsonrpc_request('{function.endpoint.path}', _request);
"""
    else:
        res += f"""
    _http_response := deribit.internal_jsonrpc_request('{function.endpoint.path}', null::text);
"""

    if function.response_type.is_array:
        res += f"""
    return query (
        select (jsonb_populate_record(
                        null::{schema}.{function.endpoint.response_type.name},
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
"""
    else:
        res += f"""
    return (jsonb_populate_record(
        null::{schema}.{function.endpoint.response_type.name}, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
"""

    res += f"""end
$$;

comment on function {schema}.{function.name} is \'{escape_comment(function.comment)}\';"""

    return res


def default_to_null_value(field: Field) -> str:
    if field.required:
        return ''
    else:
        return ' = null'


def default_test_value(field: str) -> str:
    if field == 'currency':
        return f"'BTC'"
    elif field == 'instrument_name':
        return f"'BTC-PERPETUAL'"
    elif field == 'amount':
        return '0.1::numeric'
    elif field == 'price':
        return '10000::numeric'
    elif field == 'index_name':
        return f"'btc_usd'"
    elif field == 'length':
        return '100'
    elif field == 'start_timestamp':
        return '1700319764'
    elif field == 'end_timestamp':
        return '1700406164'
    elif field == 'instrument_id':
        return '0'  # TODO
    elif field == 'resolution':
        return '1D'  # TODO

    return 'UNKNOWN'


def test_endpoint(schema: str, function: Function) -> str:
    res = ""

    res += f"""select * 
from {schema}.{function.name}("""
    if function.endpoint.request_type is not None:
        required_fields = [x for x in function.endpoint.request_type.fields if x.required]
        res += ',\n'.join(f'\n\t{escape_postgres_keyword(e.name)} := {default_test_value(escape_postgres_keyword(e.name))}' for e in required_fields)
    res += f");"

    return res

def test_endpoint_xunit(schema: str, function: Function) -> str:
    res = f"""create or replace function {schema}.test_{function.name}()
returns setof text
language plpgsql
as $$"""

    res += """
declare"""

    # expected type
    if function.response_type.is_primitive:
        res += f"""
    _expected {convert_type_postgres(schema, function.response_type.name, FieldType(name=function.response_type.name, is_enum=False, is_class=False, is_array=False))};
    """
    elif function.response_type.is_array:
        res += f"""
    _expected setof {schema}.{function.response_type.name};
    """
    else:
        res += f"""
    _expected {schema}.{function.response_type.name};
    """

    # parameters
    # if function.endpoint.request_type is not None:
    #     res += f"\n\t_request {schema}.{function.endpoint.request_type.name};"

    if function.endpoint.request_type is not None:
        res += "\n"
        res += ';\n'.join(
            f'\t_{escape_postgres_keyword(f.name)} {convert_type_postgres(schema, function.endpoint.request_type.name, f.type)}{default_to_null_value(f)}'
            for f in function.endpoint.request_type.fields)
        res += ";\n"

    res += """
begin
    """
    if function.endpoint.request_type is not None:
        res += f"""_expected := {schema}.{function.name}(
"""
        res += ',\n'.join(f'\t\t{escape_postgres_keyword(e.name)} := _{escape_postgres_keyword(e.name)}' for e in function.endpoint.request_type.fields)
        res += f"""
    );"""

    res += f"""
    
    return query (
        select results_eq(_result, _expected)
    );
"""

    res += f"""end
$$;"""

    return res
