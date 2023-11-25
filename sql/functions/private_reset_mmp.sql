drop function if exists deribit.private_reset_mmp;

create or replace function deribit.private_reset_mmp(
	index_name deribit.private_reset_mmp_request_index_name
)
returns text
language plpgsql
as $$
declare
	_request deribit.private_reset_mmp_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		index_name
    )::deribit.private_reset_mmp_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/reset_mmp'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_reset_mmp_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_reset_mmp is 'Reset MMP';

