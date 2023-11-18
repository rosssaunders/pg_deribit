create or replace function deribit.private_get_transaction_log(
	currency deribit.private_get_transaction_log_request_currency,
	start_timestamp bigint,
	end_timestamp bigint,
	query text default null,
	count bigint default null,
	continuation bigint default null
)
returns deribit.private_get_transaction_log_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_transaction_log_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		start_timestamp,
		end_timestamp,
		query,
		count,
		continuation
    )::deribit.private_get_transaction_log_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_transaction_log', _request);

    perform deribit.matching_engine_request_log_call('/private/get_transaction_log');

    return (jsonb_populate_record(
        null::deribit.private_get_transaction_log_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_transaction_log is 'Retrieve the latest user trades that have occurred for a specific instrument and within given time range.';

