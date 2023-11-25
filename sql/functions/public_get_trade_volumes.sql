drop function if exists deribit.public_get_trade_volumes;

create or replace function deribit.public_get_trade_volumes(
	extended boolean default null
)
returns setof deribit.public_get_trade_volumes_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_trade_volumes_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		extended
    )::deribit.public_get_trade_volumes_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_trade_volumes'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.public_get_trade_volumes_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.public_get_trade_volumes is 'Retrieves aggregated 24h trade volumes for different instrument types and currencies.';

