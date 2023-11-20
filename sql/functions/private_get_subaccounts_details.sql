drop function if exists deribit.private_get_subaccounts_details;
create or replace function deribit.private_get_subaccounts_details(
	currency deribit.private_get_subaccounts_details_request_currency,
	with_open_orders boolean default null
)
returns setof deribit.private_get_subaccounts_details_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_subaccounts_details_request;
    _http_response omni_httpc.http_response;
begin
    
    perform deribit.matching_engine_request_log_call('/private/get_subaccounts_details');
    
_request := row(
		currency,
		with_open_orders
    )::deribit.private_get_subaccounts_details_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_subaccounts_details', _request);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_subaccounts_details_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_subaccounts_details is 'Get subaccounts positions';

