drop function if exists deribit.public_get_funding_rate_value;

create or replace function deribit.public_get_funding_rate_value(
	instrument_name text,
	start_timestamp bigint,
	end_timestamp bigint
)
returns double precision
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			start_timestamp,
			end_timestamp
        )::deribit.public_get_funding_rate_value_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_funding_rate_value'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_funding_rate_value_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_funding_rate_value is 'Retrieves interest rate value for requested period. Applicable only for PERPETUAL instruments.';

