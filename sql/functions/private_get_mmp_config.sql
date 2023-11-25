drop function if exists deribit.private_get_mmp_config;

create or replace function deribit.private_get_mmp_config(
	index_name deribit.private_get_mmp_config_request_index_name default null
)
returns setof deribit.private_get_mmp_config_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_mmp_config_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		index_name
    )::deribit.private_get_mmp_config_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_mmp_config'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_mmp_config_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_mmp_config is 'Get MMP configuration for an index, if the parameter is not provided, a list of all MMP configurations is returned. Empty list means no MMP configuration.';

