drop function if exists deribit.private_get_positions;

create or replace function deribit.private_get_positions(
	currency deribit.private_get_positions_request_currency,
	kind deribit.private_get_positions_request_kind default null,
	subaccount_id bigint default null
)
returns setof deribit.private_get_positions_response_result
language plpgsql
as $$
declare
	_request deribit.private_get_positions_request;
    _http_response omni_httpc.http_response;
    
begin
	_request := row(
		currency,
		kind,
		subaccount_id
    )::deribit.private_get_positions_request;
    
    _http_response := deribit.internal_jsonrpc_request('/private/get_positions'::deribit.endpoint, _request, 'private_request_log_call'::name);

    return query (
        select (jsonb_populate_record(
                        null::deribit.private_get_positions_response,
                        convert_from(_http_response.body, 'utf-8')::jsonb)
             ).result
    );
end
$$;

comment on function deribit.private_get_positions is 'Retrieve user positions. To retrieve subaccount positions, use subaccount_id parameter.';

