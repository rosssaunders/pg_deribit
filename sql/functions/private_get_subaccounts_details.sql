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
	_request := row(
		currency,
		with_open_orders
    )::deribit.private_get_subaccounts_details_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_subaccounts_details'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_subaccounts_details_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_subaccounts_details is 'Get subaccounts positions';

