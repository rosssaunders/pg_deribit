create type deribit.private_get_affiliate_program_info_response_received as (
	btc float,
	eth float
);
comment on column deribit.private_get_affiliate_program_info_response_received.btc is 'Total payout received in BTC';
comment on column deribit.private_get_affiliate_program_info_response_received.eth is 'Total payout received in ETH';

create type deribit.private_get_affiliate_program_info_response_result as (
	is_enabled boolean,
	link text,
	number_of_affiliates float,
	received deribit.private_get_affiliate_program_info_response_received
);
comment on column deribit.private_get_affiliate_program_info_response_result.is_enabled is 'Status of affiliate program';
comment on column deribit.private_get_affiliate_program_info_response_result.link is 'Affliate link';
comment on column deribit.private_get_affiliate_program_info_response_result.number_of_affiliates is 'Number of affiliates';

create type deribit.private_get_affiliate_program_info_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_affiliate_program_info_response_result
);
comment on column deribit.private_get_affiliate_program_info_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_affiliate_program_info_response.jsonrpc is 'The JSON-RPC version (2.0)';

create or replace function deribit.private_get_affiliate_program_info()
returns deribit.private_get_affiliate_program_info_response_result
language plpgsql
as $$
declare
    _http_response omni_httpc.http_response;
begin
    
    _http_response:= (select deribit.jsonrpc_request('/private/get_affiliate_program_info', null));

    return (jsonb_populate_record(
        null::deribit.private_get_affiliate_program_info_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_get_affiliate_program_info is 'Retrieves user`s affiliates count, payouts and link.';

