create or replace function deribit.private_get_user_trades_by_instrument(
	instrument_name text,
	start_seq bigint default null,
	end_seq bigint default null,
	count bigint default null,
	start_timestamp bigint default null,
	end_timestamp bigint default null,
	sorting deribit.private_get_user_trades_by_instrument_request_sorting default null
)
returns deribit.private_get_user_trades_by_instrument_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_user_trades_by_instrument_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		start_seq,
		end_seq,
		count,
		start_timestamp,
		end_timestamp,
		sorting
    )::deribit.private_get_user_trades_by_instrument_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_user_trades_by_instrument', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_user_trades_by_instrument_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_user_trades_by_instrument is 'Retrieve the latest user trades that have occurred for a specific instrument.';

