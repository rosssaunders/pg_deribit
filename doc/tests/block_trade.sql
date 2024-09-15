create extension if not exists pg_deribit cascade;

-- TODO - remove this requirement
delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_approve_block_trade(
    (select row('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE')::deribit.auth),
    "timestamp" := 1618224000000::bigint,
    nonce := 'dsaf',
    role := 'maker'
);

select *
from deribit.private_execute_block_trade(
    "timestamp" := 1618224000000::bigint,
    nonce := 'dsaf',
    role := 'maker',
    counterparty_signature := 'dsaf',
    trades := array[row(
        'BTC-PERPETUAL',
        10000.0,
        1.0,
        'buy'
    )::deribit.private_execute_block_trade_request_trade]
);

select *
from deribit.private_get_block_trade(
    id := 'sdfsdf'
);

select *
from deribit.private_get_last_block_trades_by_currency(
    currency := 'BTC'
);

select *
from deribit.private_get_pending_block_trades();

select *
from deribit.private_invalidate_block_trade_signature(
    signature := '213123'
);

select *
from deribit.private_move_positions(
    source_uid := 123,
    target_uid := 124,
    trades := array[row(
        'BTC-PERPETUAL',
        10000.0,
        1.0
    )::deribit.private_move_positions_request_trade]
);

select *
from deribit.private_reject_block_trade(
    "timestamp" := 1618224000000::bigint,
    nonce := 'dsaf',
    role := 'maker'
);

select *
from deribit.private_simulate_block_trade(
    trades := array[row(
        'BTC-PERPETUAL',
        10000.0,
        1.0,
        'buy'
    )::deribit.private_simulate_block_trade_request_trade]
);

select *
from deribit.private_verify_block_trade(
    "timestamp" := 1618224000000::bigint,
    nonce := 'dsaf',
    role := 'maker',
    trades := array[row(
        'BTC-PERPETUAL',
        10000.0,
        1.0,
        'buy'
    )::deribit.private_verify_block_trade_request_trade]
);

