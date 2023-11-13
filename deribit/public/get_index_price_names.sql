insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_index_price_names', now(), 0, '0 secs'::interval);

create type deribit.public_get_index_price_names_response as (
	id bigint,
	jsonrpc text,
	result text[]
);
comment on column deribit.public_get_index_price_names_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_index_price_names_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.public_get_index_price_names()
returns text
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= deribit.internal_jsonrpc_request('/public/get_index_price_names');

    return (jsonb_populate_record(
        null::deribit.public_get_index_price_names_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_index_price_names is 'Retrieves the identifiers of all supported Price Indexes';

