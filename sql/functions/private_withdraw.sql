create or replace function deribit.private_withdraw(
	currency deribit.private_withdraw_request_currency,
	address text,
	amount float,
	priority deribit.private_withdraw_request_priority default null
)
returns deribit.private_withdraw_response_result
language plpgsql
as $$
declare
	_request deribit.private_withdraw_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		address,
		amount,
		priority
    )::deribit.private_withdraw_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/withdraw', _request);

    return (jsonb_populate_record(
        null::deribit.private_withdraw_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_withdraw is 'Creates a new withdrawal request';

