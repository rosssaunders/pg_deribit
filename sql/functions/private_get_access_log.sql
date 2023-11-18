create or replace function deribit.private_get_access_log(
	"offset" bigint default null,
	count bigint default null
)
returns setof deribit.private_get_access_log_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_access_log_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		"offset",
		count
    )::deribit.private_get_access_log_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_access_log', _request);

    perform deribit.matching_engine_request_log_call('/private/get_access_log');

    return query (
        select *
		from unnest(
             (jsonb_populate_record(
                        null::deribit.private_get_access_log_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result)
    );
end
$$;

comment on function deribit.private_get_access_log is 'Lists access logs for the user';

