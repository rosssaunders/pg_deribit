drop function if exists deribit.private_get_order_history_by_instrument;

create or replace function deribit.private_get_order_history_by_instrument(
	instrument_name text,
	count bigint default null,
	"offset" bigint default null,
	include_old boolean default null,
	include_unfilled boolean default null
)
returns setof deribit.private_get_order_history_by_instrument_response_result
language sql
as $$
    
    with request as (
        select row(
			instrument_name,
			count,
			"offset",
			include_old,
			include_unfilled
        )::deribit.private_get_order_history_by_instrument_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_order_history_by_instrument'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_order_history_by_instrument_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).reject_post_only::boolean,
		(b).label::text,
		(b).order_state::text,
		(b).usd::double precision,
		(b).implv::double precision,
		(b).trigger_reference_price::double precision,
		(b).original_order_type::text,
		(b).block_trade::boolean,
		(b).trigger_price::double precision,
		(b).api::boolean,
		(b).mmp::boolean,
		(b).trigger_order_id::text,
		(b).cancel_reason::text,
		(b).risk_reducing::boolean,
		(b).filled_amount::double precision,
		(b).instrument_name::text,
		(b).max_show::double precision,
		(b).app_name::text,
		(b).mmp_cancelled::boolean,
		(b).direction::text,
		(b).last_update_timestamp::bigint,
		(b).trigger_offset::double precision,
		(b).price::text,
		(b).is_liquidation::boolean,
		(b).reduce_only::boolean,
		(b).amount::double precision,
		(b).post_only::boolean,
		(b).mobile::boolean,
		(b).triggered::boolean,
		(b).order_id::text,
		(b).replaced::boolean,
		(b).order_type::text,
		(b).time_in_force::text,
		(b).auto_replaced::boolean,
		(b).trigger::text,
		(b).web::boolean,
		(b).creation_timestamp::bigint,
		(b).average_price::double precision,
		(b).advanced::text
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_order_history_by_instrument is 'Retrieves history of orders that have been partially or fully filled.';

