create or replace function deribit.public_get_funding_rate_history(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns setof deribit.public_get_funding_rate_history_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_funding_rate_history_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		instrument_name,
		start_timestamp,
		end_timestamp
    )::deribit.public_get_funding_rate_history_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_funding_rate_history', _request);

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.public_get_funding_rate_history_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.public_get_funding_rate_history is 'Retrieves hourly historical interest rate for requested PERPETUAL instrument.';

