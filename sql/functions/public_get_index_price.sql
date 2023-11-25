drop function if exists deribit.public_get_index_price;

create or replace function deribit.public_get_index_price(
	index_name deribit.public_get_index_price_request_index_name
)
returns deribit.public_get_index_price_response_result
language sql
as $$
    
    with request as (
        select row(
			index_name
        )::deribit.public_get_index_price_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_index_price'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_index_price_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_index_price is 'Retrieves the current index price value for given index name.';

