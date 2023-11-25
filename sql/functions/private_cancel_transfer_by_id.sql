drop function if exists deribit.private_cancel_transfer_by_id;

create or replace function deribit.private_cancel_transfer_by_id(
	currency deribit.private_cancel_transfer_by_id_request_currency,
	id bigint
)
returns deribit.private_cancel_transfer_by_id_response_result
language sql
as $$
    
    with request as (
        select row(
			currency,
			id
        )::deribit.private_cancel_transfer_by_id_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/cancel_transfer_by_id'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_cancel_transfer_by_id_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_cancel_transfer_by_id is 'Cancel transfer';

