drop function if exists deribit.private_get_user_locks;

create or replace function deribit.private_get_user_locks()
returns setof deribit.private_get_user_locks_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
    
begin

    _http_response := deribit.internal_jsonrpc_request('/private/get_user_locks'::deribit.endpoint, null::text, 'private_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_user_locks_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_user_locks is 'Retrieves information about locks on user account';

