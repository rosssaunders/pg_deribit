drop function if exists deribit.private_get_margins;

create or replace function deribit.private_get_margins(
	instrument_name text,
	amount double precision,
	price double precision
)
returns deribit.private_get_margins_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			amount,
			price
        )::deribit.private_get_margins_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_margins'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_margins_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_margins is 'Get margins for given instrument, amount and price.';

