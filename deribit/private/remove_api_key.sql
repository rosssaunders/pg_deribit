insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/remove_api_key', null, 0, '0 secs'::interval);

create type deribit.private_remove_api_key_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_remove_api_key_response.id is 'The id that was sent in the request';
comment on column deribit.private_remove_api_key_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_remove_api_key_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_remove_api_key_request as (
	id bigint
);
comment on column deribit.private_remove_api_key_request.id is '(Required) Id of key';

create or replace function deribit.private_remove_api_key(
	id bigint
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_remove_api_key_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		id
    )::deribit.private_remove_api_key_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/remove_api_key', _request);

    return (jsonb_populate_record(
        null::deribit.private_remove_api_key_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_remove_api_key is 'Removes api key. Important notes.';

