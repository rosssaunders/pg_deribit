drop type if exists deribit.public_get_supported_index_names_response cascade;
create type deribit.public_get_supported_index_names_response as (
	id bigint,
	jsonrpc text,
	result text[]
);
comment on column deribit.public_get_supported_index_names_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_supported_index_names_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_supported_index_names_request_type cascade;
create type deribit.public_get_supported_index_names_request_type as enum ('derivative', 'spot', 'all');

drop type if exists deribit.public_get_supported_index_names_request cascade;
create type deribit.public_get_supported_index_names_request as (
	type deribit.public_get_supported_index_names_request_type
);
comment on column deribit.public_get_supported_index_names_request.type is 'Type of a cryptocurrency price index';

