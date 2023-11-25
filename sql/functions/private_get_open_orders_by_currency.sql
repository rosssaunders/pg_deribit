drop function if exists deribit.private_get_open_orders_by_currency;

create or replace function deribit.private_get_open_orders_by_currency(
	currency deribit.private_get_open_orders_by_currency_request_currency,
	kind deribit.private_get_open_orders_by_currency_request_kind default null,
	type deribit.private_get_open_orders_by_currency_request_type default null
)
returns setof deribit.private_get_open_orders_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_open_orders_by_currency_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		kind,
		type
    )::deribit.private_get_open_orders_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_open_orders_by_currency'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_open_orders_by_currency_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_open_orders_by_currency is 'Retrieves list of user''s open orders.';

