drop function if exists deribit.public_get_index;

create or replace function deribit.public_get_index(
	currency deribit.public_get_index_request_currency
)
returns deribit.public_get_index_response_result
language sql
as $$
    
    with request as (
        select row(
			currency
        )::deribit.public_get_index_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_index'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_index_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_index is 'Retrieves the current index price for the instruments, for the selected currency.';

