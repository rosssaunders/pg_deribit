insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/get_user_locks', null, 0, '0 secs'::interval);

create type deribit.private_get_user_locks_response_result as (
	currency text,
	enabled boolean,
	message text
);
comment on column deribit.private_get_user_locks_response_result.currency is 'Currency, i.e "BTC", "ETH", "USDC"';
comment on column deribit.private_get_user_locks_response_result.enabled is 'Value is set to ''true'' when user account is locked in currency';
comment on column deribit.private_get_user_locks_response_result.message is 'Optional information for user why his account is locked';

create type deribit.private_get_user_locks_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_user_locks_response_result[]
);
comment on column deribit.private_get_user_locks_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_user_locks_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_get_user_locks()
returns setof deribit.private_get_user_locks_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= deribit.internal_jsonrpc_request('/private/get_user_locks');

    return query (
        select (unnest
             ((jsonb_populate_record(
                        null::deribit.private_get_user_locks_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result))
    );
end
$$;

comment on function deribit.private_get_user_locks is 'Retrieves information about locks on user account';

