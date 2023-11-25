drop function if exists deribit.private_submit_transfer_to_user;

create or replace function deribit.private_submit_transfer_to_user(
	currency deribit.private_submit_transfer_to_user_request_currency,
	amount float,
	destination text
)
returns deribit.private_submit_transfer_to_user_response_result
language plpgsql
as $$
declare
	_request deribit.private_submit_transfer_to_user_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		amount,
		destination
    )::deribit.private_submit_transfer_to_user_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/submit_transfer_to_user'::deribit.endpoint, _request, 'deribit.non_matching_engine_request_log_call'::name);

    return (jsonb_populate_record(
        null::deribit.private_submit_transfer_to_user_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_submit_transfer_to_user is 'Transfer funds to another user.';

