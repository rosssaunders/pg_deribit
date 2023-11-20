drop type if exists deribit.public_get_contract_size_response_result cascade;
create type deribit.public_get_contract_size_response_result as (
	contract_size float
);
comment on column deribit.public_get_contract_size_response_result.contract_size is 'Contract size, for futures in USD, for options in base currency of the instrument (BTC, ETH, ...)';

drop type if exists deribit.public_get_contract_size_response cascade;
create type deribit.public_get_contract_size_response as (
	id bigint,
	jsonrpc text,
	result deribit.public_get_contract_size_response_result
);
comment on column deribit.public_get_contract_size_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_contract_size_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_contract_size_request cascade;
create type deribit.public_get_contract_size_request as (
	instrument_name text
);
comment on column deribit.public_get_contract_size_request.instrument_name is '(Required) Instrument name';

