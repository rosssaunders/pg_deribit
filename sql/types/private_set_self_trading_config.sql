create type deribit.private_set_self_trading_config_response as (
	id bigint,
	jsonrpc text,
	result text
);
comment on column deribit.private_set_self_trading_config_response.id is 'The id that was sent in the request';
comment on column deribit.private_set_self_trading_config_response.jsonrpc is 'The JSON-RPC version (2.0)';
comment on column deribit.private_set_self_trading_config_response.result is 'Result of method execution. ok in case of success';

create type deribit.private_set_self_trading_config_request_mode as enum ('reject_taker', 'cancel_maker');

create type deribit.private_set_self_trading_config_request as (
	mode deribit.private_set_self_trading_config_request_mode,
	extended_to_subaccounts boolean
);
comment on column deribit.private_set_self_trading_config_request.mode is '(Required) Self trading prevention behavior: reject_taker (reject the incoming order), cancel_maker (cancel the matched order in the book)';
comment on column deribit.private_set_self_trading_config_request.extended_to_subaccounts is '(Required) If value is true trading is prevented between subaccounts of given account, otherwise they are treated separately';

