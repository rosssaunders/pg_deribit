drop function if exists deribit.public_get_last_trades_by_instrument;

create or replace function deribit.public_get_last_trades_by_instrument(
	instrument_name text,
	start_seq bigint default null,
	end_seq bigint default null,
	start_timestamp bigint default null,
	end_timestamp bigint default null,
	count bigint default null,
	sorting deribit.public_get_last_trades_by_instrument_request_sorting default null
)
returns deribit.public_get_last_trades_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_last_trades_by_instrument_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		instrument_name,
		start_seq,
		end_seq,
		start_timestamp,
		end_timestamp,
		count,
		sorting
    )::deribit.public_get_last_trades_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_last_trades_by_instrument'::deribit.endpoint, _request, 'public_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.public_get_last_trades_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_last_trades_by_instrument is 'Retrieve the latest trades that have occurred for a specific instrument.';

