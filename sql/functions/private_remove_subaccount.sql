create or replace function deribit.private_remove_subaccount(
	subaccount_id bigint
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_remove_subaccount_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		subaccount_id
    )::deribit.private_remove_subaccount_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/remove_subaccount', _request);

    return (jsonb_populate_record(
        null::deribit.private_remove_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_remove_subaccount is 'Remove empty subaccount.';

