create or replace function deribit.private_get_portfolio_margins(
	currency deribit.private_get_portfolio_margins_request_currency,
	add_positions boolean default null,
	simulated_positions jsonb default null
)
returns deribit.private_get_portfolio_margins_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_portfolio_margins_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		currency,
		add_positions,
		simulated_positions
    )::deribit.private_get_portfolio_margins_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_portfolio_margins', _request);

    return (jsonb_populate_record(
        null::deribit.private_get_portfolio_margins_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;
end
$$;

comment on function deribit.private_get_portfolio_margins is 'Calculates portfolio margin info for simulated position or current position of the user. This request has special restricted rate limit (not more than once per a second).';

