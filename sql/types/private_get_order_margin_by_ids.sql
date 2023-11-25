drop type if exists deribit.private_get_order_margin_by_ids_response_result cascade;
create type deribit.private_get_order_margin_by_ids_response_result as (
	initial_margin double precision,
	initial_margin_currency text,
	order_id text
);
comment on column deribit.private_get_order_margin_by_ids_response_result.initial_margin is 'Initial margin of order';
comment on column deribit.private_get_order_margin_by_ids_response_result.initial_margin_currency is 'Currency of initial margin';
comment on column deribit.private_get_order_margin_by_ids_response_result.order_id is 'Unique order identifier';

drop type if exists deribit.private_get_order_margin_by_ids_response cascade;
create type deribit.private_get_order_margin_by_ids_response as (
	id bigint,
	jsonrpc text,
	result deribit.private_get_order_margin_by_ids_response_result[]
);
comment on column deribit.private_get_order_margin_by_ids_response.id is 'The id that was sent in the request';
comment on column deribit.private_get_order_margin_by_ids_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.private_get_order_margin_by_ids_request cascade;
create type deribit.private_get_order_margin_by_ids_request as (
	ids UNKNOWN - array - False - False - False
);
comment on column deribit.private_get_order_margin_by_ids_request.ids is '(Required) Ids of orders';

