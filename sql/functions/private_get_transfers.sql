drop function if exists deribit.private_get_transfers;

create or replace function deribit.private_get_transfers(
	currency deribit.private_get_transfers_request_currency,
	count bigint default null,
	"offset" bigint default null
)
returns deribit.private_get_transfers_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			count,
			"offset"
        )::deribit.private_get_transfers_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_transfers'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_get_transfers_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_get_transfers is 'Retrieve the user''s transfers list';

