create or replace function deribit.public_get_last_settlements_by_instrument(
	instrument_name text,
	type deribit.public_get_last_settlements_by_instrument_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.public_get_last_settlements_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_last_settlements_by_instrument_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		type,
		count,
		continuation,
		search_start_timestamp
    )::deribit.public_get_last_settlements_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_last_settlements_by_instrument', _request);

    return (jsonb_populate_record(
        null::deribit.public_get_last_settlements_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_last_settlements_by_instrument is 'Retrieves historical public settlement, delivery and bankruptcy events filtered by instrument name.';

