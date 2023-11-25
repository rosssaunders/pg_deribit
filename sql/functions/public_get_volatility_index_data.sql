drop function if exists deribit.public_get_volatility_index_data;

create or replace function deribit.public_get_volatility_index_data(
	currency deribit.public_get_volatility_index_data_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	resolution deribit.public_get_volatility_index_data_request_resolution
)
returns deribit.public_get_volatility_index_data_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			start_timestamp,
			end_timestamp,
			resolution
        )::deribit.public_get_volatility_index_data_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/public/get_volatility_index_data'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.public_get_volatility_index_data_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.public_get_volatility_index_data is 'Public market data request for volatility index candles.';

