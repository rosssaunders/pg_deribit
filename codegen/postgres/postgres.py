# converts from the documented type to the postgres type
from codegen.models.models import Field, FieldType, Function, Type
from codegen.postgres.documentation import escape_comment, required_to_string
from codegen.postgres.keywords import escape_postgres_keyword


def convert_type_postgres(schema: str, parent_type: str, field_type: FieldType) -> str:
    if field_type.is_array:
        nested_array = False
        if field_type.type_name == 'float[]':
            return f"double precision[][]"

        data_type = convert_type_postgres(
            schema,
            parent_type,
            FieldType(type_name=field_type.type_name, is_array=False, is_class=field_type.is_class, is_enum=field_type.is_enum)
        )
        return f"{data_type}[]"
    elif field_type.is_enum:
        return f"{schema}.{parent_type}_{field_type.type_name}"
    elif field_type.is_class:
        return f"{schema}.{field_type.type_name}"
    elif field_type.type_name == 'number or string':
        return 'text'
    elif field_type.type_name == 'string':
        return 'text'
    elif field_type.type_name == 'text':
        return 'text'
    elif field_type.type_name == 'float[]':
        return 'double precision[]'
    elif field_type.type_name == 'float':
        return 'double precision'
    elif field_type.type_name == 'number':
        return 'double precision'
    elif field_type.type_name == 'decimal':
        return 'numeric'
    elif field_type.type_name == 'integer':
        return 'bigint'
    elif field_type.type_name == 'boolean':
        return 'boolean'
    elif field_type.type_name == 'object':
        return 'jsonb'
    elif field_type.type_name == 'timestamp':
        return 'timestamp'
    else:
        return f"UNKNOWN - {field_type.type_name} - {field_type.is_array} - {field_type.is_class} - {field_type.is_enum}"


def type_to_type(schema: str, type: Type) -> str:
    res = f"drop type if exists {schema}.{type.name} cascade;\n\n"
    res += f"create type {schema}.{type.name} as (\n"
    res += ',\n'.join(f'    {escape_postgres_keyword(e.name)} {convert_type_postgres(schema, type.name, e.type)}' for e in type.fields)
    res += f"\n);\n\n"

    res += '\n'.join(f'comment on column {schema}.{type.name}.{escape_postgres_keyword(e.name)} is \'{required_to_string(e.required)}{escape_comment(e.documentation)}\';' for e in type.fields if e.documentation != '')

    return res


def default_to_null(field: Field) -> str:
    if field.required:
        return ''
    else:
        return ' default null'


def sort_fields_by_required(fields: [Field]) -> [Field]:
    return sorted(fields, key=lambda e: e.required, reverse=True)


def invoke_endpoint(schema: str, function: Function) -> str:
    res = f"""drop function if exists {schema}.{function.name};\n\n"""
    res += f"""create or replace function {schema}.{function.name}("""
    if function.endpoint.request_type is not None:
        res += "\n"
        res += ',\n'.join(f'    {escape_postgres_keyword(f.name)} {convert_type_postgres(schema, function.endpoint.request_type.name, f.type)}{default_to_null(f)}' for f in sort_fields_by_required(function.endpoint.request_type.fields))
        res += "\n"
    res += f""")"""

    ######################
    # start return type
    ######################
    if function.response_type.is_array and function.response_type.is_primitive:
        res += f"""
returns setof {convert_type_postgres(schema, function.response_type.name, FieldType(type_name=function.response_type.name))}
"""

    elif function.response_type.is_array and not function.response_type.is_primitive:
        res += f"""
returns setof {schema}.{function.response_type.name}"""

    elif function.response_type.is_primitive:
        res += f"""
returns {convert_type_postgres(schema, function.response_type.name, FieldType(type_name=function.response_type.name))}"""

    else:
        res += f"""
returns {schema}.{function.response_type.name}"""

    ######################
    # end return type
    ######################

    res += """
language sql
as $$"""

    if function.endpoint.request_type is not None:
        res += """
    
    with request as (
        select row(
"""
        res += ',\n'.join(f'            {escape_postgres_keyword(e.name)}' for e in function.endpoint.request_type.fields)
        res += f"""
        )::{schema}.{function.endpoint.request_type.name} as payload
    )
    , http_response as (
        select {schema}.internal_jsonrpc_request(
            '{function.endpoint.path}'::{schema}.endpoint, 
            request.payload, 
            '{schema}.{function.endpoint.rate_limiter}'::name
        ) as http_response
        from request
    )
"""
    else:
        res += f"""
    with http_response as (
        select {schema}.internal_jsonrpc_request(
            '{function.endpoint.path}'::{schema}.endpoint, 
            null::text, 
            '{schema}.{function.endpoint.rate_limiter}'::name
        ) as http_response
    )
"""

    if function.response_type.is_array:
        res += f"""    , result as (
        select (jsonb_populate_record(
                        null::{schema}.{function.endpoint.response_type.name},
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )"""

        if function.response_type.is_nested_array:
            res += f"""
    , unnested as (
        select {schema}.unnest_2d_1d(x.x)
        from result x(x)
    )
    select 
"""
            res += ',\n'.join(
        f'        (b.x)[{i+1}]::{convert_type_postgres(schema, "", e.type)} as {escape_postgres_keyword(e.name)}' for i, e in enumerate(function.response_type.fields))
            res += """
    from unnested b(x)"""

        else:
            res += """
    select
"""
            if len(function.response_type.fields) == 0:
                res += """        a.b"""
            else:
                res += ',\n'.join(f'        (b).{escape_postgres_keyword(e.name)}::{convert_type_postgres(schema, "", e.type)}' for e in function.response_type.fields)
            res += f"""
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    """
    else:
        res += f"""    select (jsonb_populate_record(
        null::{schema}.{function.endpoint.response_type.name}, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a
"""

    ############################
    # function comment start
    ############################

    res += f"""
$$;

comment on function {schema}.{function.name} is \'{escape_comment(function.comment)}\';"""

    ############################
    # function comment end
    ############################

    return res


