drop function if exists deribit.private_get_affiliate_program_info;

create or replace function deribit.private_get_affiliate_program_info()
returns deribit.private_get_affiliate_program_info_response_result
language sql
as $$
    with http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_affiliate_program_info'::deribit.endpoint, 
            null::text, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
    )
	select (jsonb_populate_record(
        null::deribit.private_get_affiliate_program_info_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_affiliate_program_info is 'Retrieves user`s affiliates count, payouts and link.';

