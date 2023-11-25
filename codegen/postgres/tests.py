from codegen.models.models import Function, FieldType, Field
from codegen.postgres.keywords import escape_postgres_keyword
from codegen.postgres.postgres import convert_type_postgres


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
        return f"'1D'"  # TODO

    return 'UNKNOWN'


def default_to_null_value(field: Field) -> str:
    if field.required:
        return ''
    else:
        return ' = null'


def test_endpoint(schema: str, function: Function) -> str:
    res = ""

    res += f"""select * 
from {schema}.{function.name}("""
    if function.endpoint.request_type is not None:
        required_fields = [x for x in function.endpoint.request_type.fields if x.required]
        res += ',\n'.join(
            f'\n\t{escape_postgres_keyword(e.name)} := {default_test_value(escape_postgres_keyword(e.name))}' for e in
            required_fields)
    res += f"""
);"""

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
        res += ',\n'.join(f'\t\t{escape_postgres_keyword(e.name)} := _{escape_postgres_keyword(e.name)}' for e in
                          function.endpoint.request_type.fields)
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
