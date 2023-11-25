drop function if exists deribit.private_sell;

create or replace function deribit.private_sell(
	instrument_name text,
	amount double precision,
	type deribit.private_sell_request_type default null,
	label text default null,
	price double precision default null,
	time_in_force deribit.private_sell_request_time_in_force default null,
	max_show double precision default null,
	post_only boolean default null,
	reject_post_only boolean default null,
	reduce_only boolean default null,
	trigger_price double precision default null,
	trigger_offset double precision default null,
	trigger deribit.private_sell_request_trigger default null,
	advanced deribit.private_sell_request_advanced default null,
	mmp boolean default null,
	valid_until bigint default null
)
returns deribit.private_sell_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			amount,
			type,
			label,
			price,
			time_in_force,
			max_show,
			post_only,
			reject_post_only,
			reduce_only,
			trigger_price,
			trigger_offset,
			trigger,
			advanced,
			mmp,
			valid_until
        )::deribit.private_sell_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/sell'::deribit.endpoint, 
            request.payload, 
            'deribit.matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	select (jsonb_populate_record(
        null::deribit.private_sell_response, 
        convert_from((a.http_response).body, 'utf-8')::jsonb)).result
    from http_response a

$$;

comment on function deribit.private_sell is 'Places a sell order for an instrument.';

