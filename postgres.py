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
    return str(comment).replace("'", "''")


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


def invoke_endpoint(schema: str, function: Function) -> str:
    res = f"""create or replace function {schema}.{function.name}("""
    if function.endpoint.request_type is not None:
        res += "\n"
        res += ',\n'.join(f'\t{escape_postgres_keyword(f.name)} {convert_type_postgres(schema, function.endpoint.request_type.name, f.type)}{default_to_null(f)}' for f in function.endpoint.request_type.fields)
        res += "\n"
    res += f""")"""
    res += f"""
returns {schema}.{function.response_type.name}
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;"""
    if function.endpoint.request_type is not None:
        res += f"\n\t_request {schema}.{function.endpoint.request_type.name};"

    res += """
    _error_response deribit.error_response;
begin
    """
    if function.endpoint.request_type is not None:
        res += """_request := row(
"""
        res += ',\n'.join(f'\t\t{escape_postgres_keyword(e.name)}' for e in function.endpoint.request_type.fields)
        res += f"""
    )::{schema}.{function.endpoint.request_type.name};
"""

    res += f"""
    with request as (
        select json_build_object(
            'method', '{function.endpoint.path}',
            """
    if function.endpoint.request_type is None:
        res += f"""'params', null,"""
    else:
        res += """'params', jsonb_strip_nulls(to_jsonb(_request)),"""

    res += f"""
            'jsonrpc', '2.0',
            'id', nextval('deribit.jsonrpc_identifier'::regclass)
        ) as request
    ),
    auth as (
        select
            'Authorization' as key,
            'Basic ' || encode(('rvAcPbEz' || ':' || 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA')::bytea, 'base64') as value
    ),
    url as (
        select format('%s%s', base_url, end_point) as url
        from
        (
            select
                'https://test.deribit.com/api/v2' as base_url,
                '{function.endpoint.path}' as end_point
        ) as a
    )
    select
        version,
        status,
        headers,
        body,
        error
    into _http_response
    from request
    cross join auth
    cross join url
    cross join omni_httpc.http_execute(
        omni_httpc.http_request(
            method := 'POST',
            url := url.url,
            body := request.request::text::bytea,
            headers := array[row (auth.key, auth.value)::omni_http.http_header])
    ) as response
    limit 1;
    
    if _http_response.status < 200 or _http_response.status >= 300 then
        _error_response := jsonb_populate_record(null::deribit.error_response, convert_from(_http_response.body, 'utf-8')::jsonb);

        raise exception using
            message = (_error_response.error).code::text,
            detail = coalesce((_error_response.error).message, 'Unknown') ||
             case
                when (_error_response.error).data is null then ''
                 else ':' || (_error_response.error).data
             end;
    end if;
    
    return (jsonb_populate_record(
        null::{schema}.{function.endpoint.response_type.name}, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end;
$$;

comment on function {schema}.{function.name} is \'{escape_comment(function.comment)}\';"""

    return res
