drop function if exists deribit.private_get_mmp_config;

create or replace function deribit.private_get_mmp_config(
	index_name deribit.private_get_mmp_config_request_index_name default null
)
returns setof deribit.private_get_mmp_config_response_result
language sql
as $$
    
    with request as (
        select row(
			index_name
        )::deribit.private_get_mmp_config_request as payload
    )
    , http_response as (
        select deribit.internal_jsonrpc_request(
            '/private/get_mmp_config'::deribit.endpoint, 
            request.payload, 
            'deribit.non_matching_engine_request_log_call'::name
        ) as http_response
        from request
    )
	, result as (
        select (jsonb_populate_record(
                        null::deribit.private_get_mmp_config_response,
                        convert_from((http_response.http_response).body, 'utf-8')::jsonb)
             ).result
        from http_response
    )
    select
		(b).delta_limit::double precision,
		(b).frozen_time::bigint,
		(b).index_name::text,
		(b)."interval"::bigint,
		(b).quantity_limit::double precision
    from (
        select (unnest(r.data)) b
        from result r(data)
    ) a
    
$$;

comment on function deribit.private_get_mmp_config is 'Get MMP configuration for an index, if the parameter is not provided, a list of all MMP configurations is returned. Empty list means no MMP configuration.';

