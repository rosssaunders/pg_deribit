drop function if exists deribit.private_get_affiliate_program_info;

create or replace function deribit.private_get_affiliate_program_info()
returns deribit.private_get_affiliate_program_info_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
    
begin

    _http_response := deribit.internal_jsonrpc_request('/private/get_affiliate_program_info'::deribit.endpoint, null::text, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_get_affiliate_program_info_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_affiliate_program_info is 'Retrieves user`s affiliates count, payouts and link.';

