drop type if exists deribit.public_get_index_price_names_response cascade;
create type deribit.public_get_index_price_names_response as (
	id bigint,
	jsonrpc text,
	result text[]
);
comment on column deribit.public_get_index_price_names_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_index_price_names_response.jsonrpc is 'The JSON-RPC version (2.0)';

