drop function if exists deribit.private_get_withdrawals;

create or replace function deribit.private_get_withdrawals(
	currency deribit.private_get_withdrawals_request_currency,
	count bigint default null,
	"offset" bigint default null
)
returns deribit.private_get_withdrawals_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_withdrawals_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		count,
		"offset"
    )::deribit.private_get_withdrawals_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_withdrawals'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_get_withdrawals_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_withdrawals is 'Retrieve the latest users withdrawals';

