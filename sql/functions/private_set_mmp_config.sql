create or replace function deribit.private_set_mmp_config(
	index_name deribit.private_set_mmp_config_request_index_name,
	"interval" bigint,
	frozen_time bigint,
	quantity_limit float default null,
	delta_limit float default null
)
returns setof deribit.private_set_mmp_config_response_result
language plpgsql
as $$
declare
	_request deribit.private_set_mmp_config_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		index_name,
		"interval",
		frozen_time,
		quantity_limit,
		delta_limit
    )::deribit.private_set_mmp_config_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/set_mmp_config', _request);

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.private_set_mmp_config_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.private_set_mmp_config is 'Set config for MMP - triggers MMP reset';

