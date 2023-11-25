drop function if exists deribit.private_get_subaccounts;

create or replace function deribit.private_get_subaccounts(
	with_portfolio boolean default null
)
returns setof deribit.private_get_subaccounts_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_subaccounts_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		with_portfolio
    )::deribit.private_get_subaccounts_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_subaccounts'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_subaccounts_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_subaccounts is 'Get information about subaccounts';

