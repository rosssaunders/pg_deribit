from codegen.models.models import Function, FieldType, Field
from codegen.postgres.keywords import escape_postgres_keyword
from codegen.postgres.postgres import convert_type_postgres


def default_test_value(field: str) -> str:
    field_values = {
        'currency': "'BTC'",
        'instrument_name': "'BTC-PERPETUAL'",
        'amount': '0.1::numeric',
        'price': '10000::numeric',
        'index_name': "'btc_usd'",
        'length': '100',
        'start_timestamp': '1700319764',
        'end_timestamp': '1700406164',
        'instrument_id': '124972',
        'resolution': "'1D'",
        'order_id': '19025003696',
        'margin_model': "'cross_sm'",
        'language': "'en'",
        'id': '1',
        'name': "'test'",
        'announcement_id': "'1'",
        'sid': '1',
        'email': ""'test@email.com'"",
        'max_scope': '',
        'subaccount_id': '1',
        'mode': '', # TODO
        'extended_to_subaccounts': '',
        'state': 'false',
        'enabled': 'false',
        'label': 'abcde',
        'type': 'market',
        '"interval"': '1',
        'frozen_time': '1',
        'destination': '1',
        'address': '123456'
    }
    return field_values.get(field, 'UNKNOWN')


def default_to_null_value(field: Field) -> str:
    return '' if field.required else ' = null'


def test_endpoint(schema: str, function: Function) -> str:
    res = ""

    res += f"""select * 
from {schema}.{function.name}("""
    if function.endpoint.request_type is not None:
        required_fields = list([x for x in function.endpoint.request_type.fields if x.required])
        if len(required_fields) > 0:
            res += """
"""
            res += ',\n'.join(
                f'\t{escape_postgres_keyword(e.name)} := {default_test_value(escape_postgres_keyword(e.name))}' for e in
                required_fields)
            res += """
"""
    res += f""");"""

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
