/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
drop type if exists deribit.public_get_order_book_by_instrument_id_response_stats cascade;

create type deribit.public_get_order_book_by_instrument_id_response_stats as (
    high double precision,
    low double precision,
    price_change double precision,
    volume double precision,
    volume_usd double precision
);

comment on column deribit.public_get_order_book_by_instrument_id_response_stats.high is 'Highest price during 24h';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats.low is 'Lowest price during 24h';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats.price_change is '24-hour price change expressed as a percentage, null if there weren''t any trades';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats.volume is 'Volume during last 24h in base currency';
comment on column deribit.public_get_order_book_by_instrument_id_response_stats.volume_usd is 'Volume in usd (futures only)';

drop type if exists deribit.public_get_order_book_by_instrument_id_response_greeks cascade;

create type deribit.public_get_order_book_by_instrument_id_response_greeks as (
    delta double precision,
    gamma double precision,
    rho double precision,
    theta double precision,
    vega double precision
);

comment on column deribit.public_get_order_book_by_instrument_id_response_greeks.delta is '(Only for option) The delta value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks.gamma is '(Only for option) The gamma value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks.rho is '(Only for option) The rho value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks.theta is '(Only for option) The theta value for the option';
comment on column deribit.public_get_order_book_by_instrument_id_response_greeks.vega is '(Only for option) The vega value for the option';

drop type if exists deribit.public_get_order_book_by_instrument_id_response_result cascade;

create type deribit.public_get_order_book_by_instrument_id_response_result as (
    ask_iv double precision,
    asks double precision[][],
    best_ask_amount double precision,
    best_ask_price double precision,
    best_bid_amount double precision,
    best_bid_price double precision,
    bid_iv double precision,
    bids double precision[][],
    current_funding double precision,
    delivery_price double precision,
    funding_8h double precision,
    greeks deribit.public_get_order_book_by_instrument_id_response_greeks,
    index_price double precision,
    instrument_name text,
    interest_rate double precision,
    last_price double precision,
    mark_iv double precision,
    mark_price double precision,
    max_price double precision,
    min_price double precision,
    open_interest double precision,
    settlement_price double precision,
    state text,
    stats deribit.public_get_order_book_by_instrument_id_response_stats,
    timestamp bigint,
    underlying_index double precision,
    underlying_price double precision
);

comment on column deribit.public_get_order_book_by_instrument_id_response_result.ask_iv is '(Only for option) implied volatility for best ask';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.asks is 'List of asks';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.best_ask_amount is 'It represents the requested order size of all best asks';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.best_ask_price is 'The current best ask price, null if there aren''t any asks';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.best_bid_amount is 'It represents the requested order size of all best bids';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.best_bid_price is 'The current best bid price, null if there aren''t any bids';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.bid_iv is '(Only for option) implied volatility for best bid';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.bids is 'List of bids';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.current_funding is 'Current funding (perpetual only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.delivery_price is 'The settlement price for the instrument. Only when state = closed';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.funding_8h is 'Funding 8h (perpetual only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.greeks is 'Only for options';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.index_price is 'Current index price';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.instrument_name is 'Unique instrument identifier';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.interest_rate is 'Interest rate used in implied volatility calculations (options only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.last_price is 'The price for the last trade';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.mark_iv is '(Only for option) implied volatility for mark price';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.mark_price is 'The mark price for the instrument';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.max_price is 'The maximum price for the future. Any buy orders you submit higher than this price, will be clamped to this maximum.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.min_price is 'The minimum price for the future. Any sell orders you submit lower than this price will be clamped to this minimum.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.open_interest is 'The total amount of outstanding contracts in the corresponding amount units. For perpetual and futures the amount is in USD units, for options it is amount of corresponding cryptocurrency contracts, e.g., BTC or ETH.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.settlement_price is 'Optional (not added for spot). The settlement price for the instrument. Only when state = open';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.state is 'The state of the order book. Possible values are open and closed.';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.timestamp is 'The timestamp (milliseconds since the Unix epoch)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.underlying_index is 'Name of the underlying future, or index_price (options only)';
comment on column deribit.public_get_order_book_by_instrument_id_response_result.underlying_price is 'Underlying price for implied volatility calculations (options only)';

drop type if exists deribit.public_get_order_book_by_instrument_id_response cascade;

create type deribit.public_get_order_book_by_instrument_id_response as (
    id bigint,
    jsonrpc text,
    result deribit.public_get_order_book_by_instrument_id_response_result
);

comment on column deribit.public_get_order_book_by_instrument_id_response.id is 'The id that was sent in the request';
comment on column deribit.public_get_order_book_by_instrument_id_response.jsonrpc is 'The JSON-RPC version (2.0)';

drop type if exists deribit.public_get_order_book_by_instrument_id_request_depth cascade;

create type deribit.public_get_order_book_by_instrument_id_request_depth as enum (
    '1',
    '10',
    '100',
    '1000',
    '10000',
    '20',
    '5',
    '50'
);

drop type if exists deribit.public_get_order_book_by_instrument_id_request cascade;

create type deribit.public_get_order_book_by_instrument_id_request as (
    instrument_id bigint,
    depth deribit.public_get_order_book_by_instrument_id_request_depth
);

comment on column deribit.public_get_order_book_by_instrument_id_request.instrument_id is '(Required) The instrument ID for which to retrieve the order book, see public/get_instruments to obtain instrument IDs.';
comment on column deribit.public_get_order_book_by_instrument_id_request.depth is 'The number of entries to return for bids and asks.';
