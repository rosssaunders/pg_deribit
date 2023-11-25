drop function if exists deribit.private_cancel_all_by_instrument;

create or replace function deribit.private_cancel_all_by_instrument(
	instrument_name text,
	type deribit.private_cancel_all_by_instrument_request_type default null,
	detailed boolean default null,
	include_combos boolean default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_all_by_instrument_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		instrument_name,
		type,
		detailed,
		include_combos
    )::deribit.private_cancel_all_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/cancel_all_by_instrument'::deribit.endpoint, _request, 'matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_cancel_all_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_cancel_all_by_instrument is 'Cancels all orders by instrument, optionally filtered by order type.';

