drop function if exists deribit.public_get_currencies;
create or replace function deribit.public_get_currencies()
returns setof deribit.public_get_currencies_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/public/get_currencies');
    

    _http_response := deribit.internal_jsonrpc_request('/public/get_currencies', null::text);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_currencies_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_currencies is 'Retrieves all cryptocurrencies supported by the API.';

