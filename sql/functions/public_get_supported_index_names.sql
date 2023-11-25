drop function if exists deribit.public_get_supported_index_names;

create or replace function deribit.public_get_supported_index_names(
	type deribit.public_get_supported_index_names_request_type default null
)
returns setof text

language plpgsql
as $$
declare
	_request deribit.public_get_supported_index_names_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		type
    )::deribit.public_get_supported_index_names_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_supported_index_names'::deribit.endpoint, _request, 'public_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_supported_index_names_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_supported_index_names is 'Retrieves the identifiers of all supported Price Indexes';

