drop function if exists deribit.public_get_delivery_prices;

create or replace function deribit.public_get_delivery_prices(
	index_name deribit.public_get_delivery_prices_request_index_name,
	"offset" bigint default null,
	count bigint default null
)
returns deribit.public_get_delivery_prices_response_result
language plpgsql
as $$
declare
	_request deribit.public_get_delivery_prices_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		index_name,
		"offset",
		count
    )::deribit.public_get_delivery_prices_request;
    
    _http_response := deribit.internal_jsonrpc_request('/public/get_delivery_prices'::deribit.endpoint, _request, 'public_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.public_get_delivery_prices_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.public_get_delivery_prices is 'Retrives delivery prices for then given index';

