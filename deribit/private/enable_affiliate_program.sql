insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/enable_affiliate_program', null, 0, '0 secs'::interval);

create type deribit.private_enable_affiliate_program_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_enable_affiliate_program_response.id is 'The id that was sent in the request';
comment on column deribit.private_enable_affiliate_program_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_enable_affiliate_program_response.result is 'Result of method execution. ok in case of success';

create or replace function deribit.private_enable_affiliate_program()
returns text
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= deribit.internal_jsonrpc_request('/private/enable_affiliate_program');

    return (jsonb_populate_record(
        null::deribit.private_enable_affiliate_program_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_enable_affiliate_program is 'Enables affilate program for user';

