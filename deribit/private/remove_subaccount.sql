create type deribit.private_remove_subaccount_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_remove_subaccount_response.id is 'The id that was sent in the request';
comment on column deribit.private_remove_subaccount_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_remove_subaccount_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_remove_subaccount_request as (
	subaccount_id bigint
);
comment on column deribit.private_remove_subaccount_request.subaccount_id is '(Required) The user id for the subaccount';

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
    
    _http_response := (select deribit.jsonrpc_request('/private/remove_subaccount', _request));

    return (jsonb_populate_record(
        null::deribit.private_remove_subaccount_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_remove_subaccount is 'Remove empty subaccount.';

