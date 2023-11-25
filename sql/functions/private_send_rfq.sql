drop function if exists deribit.private_send_rfq;

create or replace function deribit.private_send_rfq(
	instrument_name text,
	amount double precision default null,
	side deribit.private_send_rfq_request_side default null
)
returns text
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			amount,
			side
        )::deribit.private_send_rfq_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/send_rfq'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_send_rfq_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_send_rfq is 'Sends RFQ on a given instrument.';

