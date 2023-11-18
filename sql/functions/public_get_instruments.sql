create or replace function deribit.public_get_instruments(
	currency deribit.public_get_instruments_request_currency,
	kind deribit.public_get_instruments_request_kind default null,
	expired boolean default null
)
returns setof deribit.public_get_instruments_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_instruments_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		kind,
		expired
    )::deribit.public_get_instruments_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_instruments', _request);

    perform deribit.matching_engine_request_log_call('/public/get_instruments');

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.public_get_instruments_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.public_get_instruments is 'Retrieves available trading instruments. This method can be used to see which instruments are available for trading, or which instruments have recently expired.';

