drop type if exists deribit.private_cancel_all_response cascade;
create type deribit.private_cancel_all_response as (
	id bigint,
	jsonrpc text,
	result double precision
);
comment on column deribit.private_cancel_all_response.id is 'The id that was sent in the request';
comment on column deribit.private_cancel_all_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_cancel_all_response.result is 'Total number of successfully cancelled orders';

drop type if exists deribit.private_cancel_all_request cascade;
create type deribit.private_cancel_all_request as (
	detailed boolean
);
comment on column deribit.private_cancel_all_request.detailed is 'When detailed is set to true output format is changed. See description. Default: false';

