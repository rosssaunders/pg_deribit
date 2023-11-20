drop function if exists deribit.private_get_order_history_by_currency;
create or replace function deribit.private_get_order_history_by_currency(
	currency deribit.private_get_order_history_by_currency_request_currency,
	kind deribit.private_get_order_history_by_currency_request_kind default null,
	count bigint default null,
	"offset" bigint default null,
	include_old boolean default null,
	include_unfilled boolean default null
)
returns setof deribit.private_get_order_history_by_currency_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_order_history_by_currency_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_order_history_by_currency');
    
_request := row(
		currency,
		kind,
		count,
		"offset",
		include_old,
		include_unfilled
    )::deribit.private_get_order_history_by_currency_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_order_history_by_currency', _request);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_order_history_by_currency_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_order_history_by_currency is 'Retrieves history of orders that have been partially or fully filled.';

