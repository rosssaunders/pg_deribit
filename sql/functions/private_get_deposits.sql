drop function if exists deribit.private_get_deposits;

create or replace function deribit.private_get_deposits(
	currency deribit.private_get_deposits_request_currency,
	count bigint default null,
	"offset" bigint default null
)
returns deribit.private_get_deposits_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			count,
			"offset"
        )::deribit.private_get_deposits_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_deposits'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_deposits_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_deposits is 'Retrieve the latest users deposits';

