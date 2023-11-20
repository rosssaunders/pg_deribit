drop type if exists deribit.private_enable_affiliate_program_response cascade;
create type deribit.private_enable_affiliate_program_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_enable_affiliate_program_response.id is 'The id that was sent in the request';
comment on column deribit.private_enable_affiliate_program_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_enable_affiliate_program_response.result is 'Result of method execution. ok in case of success';

