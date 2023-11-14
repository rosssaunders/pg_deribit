insert into deribit.internal_endpoint_rate_limit (key, last_call, calls, time_waiting) 
values 
('private/reset_mmp', null, 0, '0 secs'::interval);

create type deribit.private_reset_mmp_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_reset_mmp_response.id is 'The id that was sent in the request';
comment on column deribit.private_reset_mmp_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_reset_mmp_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_reset_mmp_request_index_name as enum ('btc_usd', 'eth_usd', 'btc_usdc', 'eth_usdc', 'ada_usdc', 'algo_usdc', 'avax_usdc', 'bch_usdc', 'bnb_usdc', 'doge_usdc', 'dot_usdc', 'link_usdc', 'ltc_usdc', 'luna_usdc', 'matic_usdc', 'mshib_usdc', 'near_usdc', 'shib_usdc', 'trx_usdc', 'uni_usdc', 'xrp_usdc', 'btcdvol_usdc', 'ethdvol_usdc');

create type deribit.private_reset_mmp_request as (
	index_name deribit.private_reset_mmp_request_index_name
);
comment on column deribit.private_reset_mmp_request.index_name is '(Required) Index identifier of derivative instrument on the platform';

create or replace function deribit.private_reset_mmp(
	index_name deribit.private_reset_mmp_request_index_name
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_reset_mmp_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		index_name
    )::deribit.private_reset_mmp_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/reset_mmp', _request);

    return (jsonb_populate_record(
        null::deribit.private_reset_mmp_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_reset_mmp is 'Reset MMP';

