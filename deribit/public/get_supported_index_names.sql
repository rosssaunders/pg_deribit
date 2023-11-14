insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('public/get_supported_index_names', null, 0, '0 secs'::interval);

create type deribit.public_get_supported_index_names_response as (
	id bigint,
	jsonrpc text,
	result text[]
);
comment on column deribit.public_get_supported_index_names_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_supported_index_names_response.jsonrpc is 'The JSON-RPC version (2.0)';

create type deribit.public_get_supported_index_names_request_type as enum ('all', 'spot', 'derivative');

create type deribit.public_get_supported_index_names_request as (
	type deribit.public_get_supported_index_names_request_type
);
comment on column deribit.public_get_supported_index_names_request.type is 'Type of a cryptocurrency price index';

create or replace function deribit.public_get_supported_index_names(
	type deribit.public_get_supported_index_names_request_type default null
)
returns text
language plpgsql
as $$
declare
	_request deribit.public_get_supported_index_names_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		type
    )::deribit.public_get_supported_index_names_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_supported_index_names', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_supported_index_names_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_supported_index_names is 'Retrieves the identifiers of all supported Price Indexes';

