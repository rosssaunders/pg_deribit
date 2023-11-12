create type deribit.private_cancel_by_label_response as (
	id bigint,
	jsonrpc text,
	result float
);
comment on column deribit.private_cancel_by_label_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_by_label_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_by_label_response.result is 'Total number of successfully cancelled orders';

create type deribit.private_cancel_by_label_request_currency as enum ('BTC', 'ETH', 'USDC');

create type deribit.private_cancel_by_label_request as (
	label text,
	currency deribit.private_cancel_by_label_request_currency
);
comment on column deribit.private_cancel_by_label_request.label is '(Required) user defined label for the order (maximum 64 characters)';
comment on column deribit.private_cancel_by_label_request.currency is 'The currency symbol';

create or replace function deribit.private_cancel_by_label(
	label text,
	currency deribit.private_cancel_by_label_request_currency default null
)
returns float
language plpgsql
as $$
declare
	_request deribit.private_cancel_by_label_request;
    _http_response omni_httpc.http_response;
begin
    _request := row(
		label,
		currency
    )::deribit.private_cancel_by_label_request;
    
    _http_response := (select deribit.jsonrpc_request('/private/cancel_by_label', _request));

    return (jsonb_populate_record(
        null::deribit.private_cancel_by_label_response, 
        convert_from(_http_response.body, 'utf-8')::jsonb)).result;

end
$$;

comment on function deribit.private_cancel_by_label is 'Cancels orders by label. All user''s orders (trigger orders too), with given label are canceled in all currencies or in one given currency (in this case currency queue is used) ';

