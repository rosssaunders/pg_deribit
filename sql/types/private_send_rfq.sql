create type deribit.private_send_rfq_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_send_rfq_response.id is 'The id that was sent in the request';
comment on column deribit.private_send_rfq_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_send_rfq_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_send_rfq_request_side as enum ('buy', 'sell');

create type deribit.private_send_rfq_request as (
	instrument_name text,
	amount float,
	side deribit.private_send_rfq_request_side
);
comment on column deribit.private_send_rfq_request.instrument_name is '(Required) Instrument name';
comment on column deribit.private_send_rfq_request.amount is 'Amount';
comment on column deribit.private_send_rfq_request.side is 'Side - buy or sell';

