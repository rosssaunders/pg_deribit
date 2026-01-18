# converts from the documented type to the postgres type
from typing import List

from models.models import Field, Function, TypeDefinition
from postgres.documentation import escape_comment, required_to_string
from postgres.keywords import escape_postgres_keyword


def convert_type_postgres(
    schema: str, parent_type: str, field_type: TypeDefinition
) -> str:
    type_name = field_type.name
    type_dict = {
        "number or string": "text",
        "string": "text",
        "text": "text",
        "float": "double precision",
        "number": "double precision",
        "decimal": "numeric",
        "integer": "bigint",
        "boolean": "boolean",
        "object": "jsonb",
        "json": "jsonb",
        "timestamp": "timestamp",
        "map": "jsonb",
    }

    if field_type.is_array:
        if type_name == "float[]":
            return "double precision[][]"
        else:
            t = TypeDefinition(type_name)
            t.is_class = field_type.is_class
            t.is_enum = field_type.is_enum
            data_type = convert_type_postgres(schema, parent_type, t)
            return f"{data_type}[]"
    elif field_type.is_enum:
        return f"{schema}.{parent_type}_{type_name}"
    elif field_type.is_class:
        return f"{schema}.{type_name}"
    elif type_name in type_dict:
        return type_dict[type_name]
    else:
        return f"UNKNOWN - {type_name} - {field_type.is_array} - {field_type.is_class} - {field_type.is_enum}"


def type_to_type(schema: str, type_: TypeDefinition) -> str:
    # res = f"drop type if exists {schema}.{type_.name} cascade;\n\n"
    res = f"create type {schema}.{type_.name} as (\n"
    res += ",\n".join(
        f"    {escape_postgres_keyword(e.name)} {convert_type_postgres(schema, type_.name, e.type)}"
        for e in type_.fields
    )
    res += f"\n);"

    comments = "\n".join(
        f"comment on column {schema}.{type_.name}.{escape_postgres_keyword(e.name)} is '{required_to_string(e.required)}{escape_comment(e.documentation)}';"
        for e in type_.fields
        if e.documentation != ""
    )
    if len(comments) > 0:
        res += "\n\n" + comments

    return res


def default_to_null(field: Field) -> str:
    if field.required:
        return ""
    else:
        return " default null"


def sort_fields_by_required(fields: List[Field]) -> List[Field]:
    return sorted(fields, key=lambda e: e.required, reverse=True)

def invoke_endpoint(schema: str, function: Function) -> str:
    public_private = ""
    res = ""
    if function.requires_auth:
        public_private = "private"
        res = f"""create function {schema}.{function.name}("""
    else:
        public_private = "public"
        res = f"""create function {schema}.{function.name}("""

    if function.endpoint.request_type is not None:
        res += "\n"
        res += ",\n".join(
            f"    {escape_postgres_keyword(f.name)} {convert_type_postgres(schema, function.endpoint.request_type.name, f.type)}{default_to_null(f)}"
            for f in sort_fields_by_required(function.endpoint.request_type.fields)
        )
        res += "\n"
    res += f""")"""

    ######################
    # start return type
    ######################
    if function.response_type is None:
        res += f"""
returns void"""

    elif function.response_type.is_array and function.response_type.is_primitive:
        res += f"""
returns setof {convert_type_postgres(schema, function.response_type.name, TypeDefinition(name=function.response_type.name))}"""

    elif function.response_type.is_array and not function.response_type.is_primitive:
        res += f"""
returns setof {schema}.{function.response_type.name}"""

    elif function.response_type.is_primitive:
        res += f"""
returns {convert_type_postgres(schema, function.response_type.name, TypeDefinition(name=function.response_type.name))}"""

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
        res += ",\n".join(
            f"            {escape_postgres_keyword(e.name)}"
            for e in function.endpoint.request_type.fields
        )
        res += f"""
        )::{schema}.{function.endpoint.request_type.name} as payload
    ), 
    http_response as (
    """

        res += f"""    select {schema}.{public_private}_jsonrpc_request("""

        if public_private == "private":
            res += """
            auth := deribit.get_auth(),"""

        res += f"""
            url := '{function.endpoint.path}'::{schema}.endpoint,
            request := request.payload,
            rate_limiter := '{schema}.{function.endpoint.rate_limiter}'::name
        ) as http_response
        from request
    )"""
    else:
        res += f"""
    with http_response as (
        select {schema}.{public_private}_jsonrpc_request("""

        if public_private == "private":
            res += """
            auth := deribit.get_auth(),"""

        res += f"""
            url := '{function.endpoint.path}'::{schema}.endpoint,
            request := null::text,
            rate_limiter := '{schema}.{function.endpoint.rate_limiter}'::name
        ) as http_response
    )"""

    if function.response_type is None:
        res += f"""
            select null::void as result
        """
    elif function.response_type.is_array:
        if function.endpoint.name == "public_get_index_price_names":
            res += f""",
    result as (
        select convert_from((http_response.http_response).body, 'utf-8')::jsonb as body
        from http_response
    )
    select
        case
            when jsonb_typeof(elem) = 'string' then null
            else (elem->>'future_combo_creation_enabled')::boolean
        end as future_combo_creation_enabled,
        case
            when jsonb_typeof(elem) = 'string' then elem #>> '{{}}'
            else elem->>'name'
        end as name,
        case
            when jsonb_typeof(elem) = 'string' then null
            else (elem->>'option_combo_creation_enabled')::boolean
        end as option_combo_creation_enabled
    from result r
    cross join lateral jsonb_array_elements(r.body->'result') elem
"""
        else:
            res += f""",
    result as (
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
                res += ",\n".join(
                    f'        (b.x)[{i+1}]::{convert_type_postgres(schema, "", e.type)} as {escape_postgres_keyword(e.name)}'
                    for i, e in enumerate(function.response_type.fields)
                )
                res += """
    from unnested b(x)"""

            else:
                res += """
    select
"""
                if len(function.response_type.fields) == 0:
                    res += """        a.b"""
                else:
                    res += ",\n".join(
                        f'        (b).{escape_postgres_keyword(e.name)}::{convert_type_postgres(schema, "", e.type)}'
                        for e in function.response_type.fields
                    )
                res += f"""
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    """
    else:
        res += f"""\n    select (
        jsonb_populate_record(
            null::{schema}.{function.endpoint.response_type.name},
            convert_from((a.http_response).body, 'utf-8')::jsonb
        )
    ).result
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
