drop function if exists deribit.public_get_mark_price_history;

create or replace function deribit.public_get_mark_price_history(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns setof deribit.public_get_mark_price_history_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_mark_price_history_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		instrument_name,
		start_timestamp,
		end_timestamp
    )::deribit.public_get_mark_price_history_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_mark_price_history'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_mark_price_history_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_mark_price_history is 'Public request for 5min history of markprice values for the instrument. For now the markprice history is available only for a subset of options which take part in the volatility index calculations. All other instruments, futures and perpetuals will return empty list.';

