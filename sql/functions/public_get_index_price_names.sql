create or replace function deribit.public_get_index_price_names()
returns text
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_index_price_names', null::text);

    return (jsonb_populate_record(
        null::deribit.public_get_index_price_names_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_index_price_names is 'Retrieves the identifiers of all supported Price Indexes';

