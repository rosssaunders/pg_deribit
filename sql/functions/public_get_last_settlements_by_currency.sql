drop function if exists deribit.public_get_last_settlements_by_currency;

create or replace function deribit.public_get_last_settlements_by_currency(
	currency deribit.public_get_last_settlements_by_currency_request_currency,
	type deribit.public_get_last_settlements_by_currency_request_type default null,
	count bigint default null,
	continuation text default null,
	search_start_timestamp bigint default null
)
returns deribit.public_get_last_settlements_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_last_settlements_by_currency_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		type,
		count,
		continuation,
		search_start_timestamp
    )::deribit.public_get_last_settlements_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_last_settlements_by_currency'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.public_get_last_settlements_by_currency_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_last_settlements_by_currency is 'Retrieves historical settlement, delivery and bankruptcy events coming from all instruments within given currency.';

