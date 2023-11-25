drop function if exists deribit.public_get_delivery_prices;

create or replace function deribit.public_get_delivery_prices(
	index_name deribit.public_get_delivery_prices_request_index_name,
	"offset" bigint default null,
	count bigint default null
)
returns deribit.public_get_delivery_prices_response_result
language sql
as $$
    
    with request as (
        select row(
			index_name,
			"offset",
			count
        )::deribit.public_get_delivery_prices_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_delivery_prices'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_delivery_prices_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_delivery_prices is 'Retrives delivery prices for then given index';

