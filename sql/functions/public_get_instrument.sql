drop function if exists deribit.public_get_instrument;

create or replace function deribit.public_get_instrument(
	instrument_name text
)
returns deribit.public_get_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name
        )::deribit.public_get_instrument_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_instrument'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_instrument_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_instrument is 'Retrieves information about instrument';

