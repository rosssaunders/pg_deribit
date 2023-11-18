create or replace function deribit.private_enable_affiliate_program()
returns text
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response := deribit.internal_jsonrpc_request('/private/enable_affiliate_program', null::text);

    return (jsonb_populate_record(
        null::deribit.private_enable_affiliate_program_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_enable_affiliate_program is 'Enables affilate program for user';

