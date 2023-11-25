drop function if exists deribit.private_get_transfers;

create or replace function deribit.private_get_transfers(
	currency deribit.private_get_transfers_request_currency,
	count bigint default null,
	"offset" bigint default null
)
returns deribit.private_get_transfers_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_transfers_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		count,
		"offset"
    )::deribit.private_get_transfers_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_transfers'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_get_transfers_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_transfers is 'Retrieve the user''s transfers list';

