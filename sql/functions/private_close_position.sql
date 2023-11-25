drop function if exists deribit.private_close_position;

create or replace function deribit.private_close_position(
	instrument_name text,
	type deribit.private_close_position_request_type,
	price double precision default null
)
returns deribit.private_close_position_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			type,
			price
        )::deribit.private_close_position_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/close_position'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_close_position_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_close_position is 'Makes closing position reduce only order .';

