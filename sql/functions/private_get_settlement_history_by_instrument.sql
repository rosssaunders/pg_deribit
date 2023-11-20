drop function if exists deribit.private_get_settlement_history_by_instrument;
create or replace function deribit.private_get_settlement_history_by_instrument(
	instrument_name text,
	type deribit.private_get_settlement_history_by_instrument_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.private_get_settlement_history_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_settlement_history_by_instrument_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_settlement_history_by_instrument');
    
_request := row(
		instrument_name,
		type,
		count,
		continuation,
		search_start_timestamp
    )::deribit.private_get_settlement_history_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_settlement_history_by_instrument', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_settlement_history_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_settlement_history_by_instrument is 'Retrieves public settlement, delivery and bankruptcy events filtered by instrument name';

