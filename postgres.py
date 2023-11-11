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
        'user', 'using', 'variadic', 'when', 'where', 'window', 'with'
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
    # check if the string ends with 'enum'
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
    elif field_type.name == 'array':
        return 'text[]'
    else:
        return f"UNKNOWN - {field_type.name}"


def escape_comment(comment: str) -> str:
    return comment.replace("'", "''")


def enum_to_type(schema: str, parent_type: str, enum: Enum) -> str:
    enums = ', '.join(f'\'{e}\'' for e in enum.items)
    return f"create type {schema}.{parent_type}_{enum.name} as enum ({enums});"


def type_to_type(schema: str, type: Type) -> str:
    res = f"create type {schema}.{type.name} as (\n"
    res += ',\n'.join(f'\t{escape_postgres_keyword(e.name)} {convert_type_postgres(schema, type.name, e.type)}' for e in type.fields)
    res += f"\n);\n"

    res += '\n'.join(f'comment on column {schema}.{type.name}.{escape_postgres_keyword(e.name)} is \'{required_to_string(e.required)}{escape_comment(e.comment)}\';' for e in type.fields if e.comment != '')

    return res


def default_to_null(field: Field) -> str:
    if field.required:
        return ''
    else:
        return ' default null'

def invoke_endpoint(schema: str, request_type: Type, function: Function) -> str:
    res = f"create or replace function {schema}.{function.name}(\n"
    res += ',\n'.join(f'\t{escape_postgres_keyword(f.name)} {convert_type_postgres(schema, request_type.name, f.type)}{default_to_null(f)}' for f in request_type.fields)
    res += f"\n)\n"
    res += f"returns {schema}.{function.response_type.name}\n"
    res += f"language plpgsql\n"
    res += f"as $$\n"
    res += f"declare\n"
    res += f"\t_request {schema}.{request_type.name};\n"
    res += f"\t_response {schema}.{function.response_type.name};\n"
    res += f"begin\n"
    res += f"\t_request := row(\n"
    res += ',\n'.join(f'\t\t{escape_postgres_keyword(e.name)}' for e in request_type.fields)
    res += f"\n\t)::{schema}.{request_type.name};\n\n"
    res += f"\twith request as (\n"
    res += f"\t\tselect json_build_object(\n"
    res += f"\t\t\t'method', '{function.path}',\n"
    res += f"\t\t\t'params', jsonb_strip_nulls(to_jsonb(_request)),\n"
    res += f"\t\t\t'jsonrpc', '2.0',\n"
    res += f"\t\t\t'id', 3\n"
    res += f"\t\t) as request\n"
    res += f"\t),\n"
    res += f"\tauth as (\n"
    res += f"\t\tselect\n"
    res += f"\t\t\t'Authorization' as key,\n"
    res += f"\t\t\t'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64') as value\n"
    res += f"\t),\n"
    res += f"\turl as (\n"
    res += f"\t\tselect format('%s%s', base_url, end_point) as url\n"
    res += f"\t\tfrom\n"
    res += f"\t\t(\n"
    res += f"\t\t\tselect\n"
    res += f"\t\t\t\t'https://test.deribit.com/api/v2' as base_url,\n"
    res += f"\t\t\t\t'{function.path}' as end_point\n"
    res += f"\t\t) as a\n"
    res += f"\t),\n"
    res += f"\texec as (\n"
    res += f"\t\tselect\n"
    res += f"\t\t\tversion,\n"
    res += f"\t\t\tstatus,\n"
    res += f"\t\t\theaders,\n"
    res += f"\t\t\tbody,\n"
    res += f"\t\t\terror\n"
    res += f"\t\tfrom request\n"
    res += f"\t\tcross join auth\n"
    res += f"\t\tcross join url\n"
    res += f"\t\tcross join omni_httpc.http_execute(\n"
    res += f"\t\t\tomni_httpc.http_request(\n"
    res += f"\t\t\t\tmethod := 'POST',\n"
    res += f"\t\t\t\turl := url.url,\n"
    res += f"\t\t\t\tbody := request.request::text::bytea,\n"
    res += f"\t\t\t\theaders := array[row (auth.key, auth.value)::omni_http.http_header])\n"
    res += f"\t\t) as response\n"
    res += f"\t)\n"
    res += f"\tselect\n"
    res += f"\t\ti.id,\n"
    res += f"\t\ti.jsonrpc,\n"
    res += f"\t\ti.result\n"
    res += f"\tinto\n"
    res += f"\t\t_response\n"
    res += f"\tfrom exec\n"
    res += f"\tcross join lateral jsonb_populate_record(null::{schema}.{function.response_type.name}, convert_from(body, 'utf-8')::jsonb) i;\n\n"
    res += f"\treturn _response;\n"
    res += f"end;\n"
    res += f"$$;\n"

    res += f"comment on function {schema}.{function.name} is \'{escape_comment(function.comment)}\';"

    return res


