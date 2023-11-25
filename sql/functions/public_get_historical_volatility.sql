drop function if exists deribit.public_get_historical_volatility;

create or replace function deribit.public_get_historical_volatility(
	currency deribit.public_get_historical_volatility_request_currency
)
returns setof deribit.public_get_historical_volatility_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_historical_volatility_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency
    )::deribit.public_get_historical_volatility_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_historical_volatility'::deribit.endpoint, _request, 'public_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_historical_volatility_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_historical_volatility is 'Provides information about historical volatility for given cryptocurrency.';

