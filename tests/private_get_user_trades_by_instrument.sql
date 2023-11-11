with recursive trades as (
    select a.result
    from deribit.private_get_user_trades_by_instrument(
              deribit.private_get_user_trades_by_instrument_request_builder(
                      instrument_name := 'ETH-PERPETUAL',
                      count := 1,
                      start_timestamp := 0,
                      sorting := 'asc'
        )
    ) a
    union all
    select b.result
    from trades t
    cross join deribit.private_get_user_trades_by_instrument(
              deribit.private_get_user_trades_by_instrument_request_builder(
                      instrument_name := 'ETH-PERPETUAL',
                      sorting := 'asc',
                      count := 100,
                      start_seq := (select max(v.trade_seq) from unnest((t.result).trades) v) + 1
        )
    ) b
    where (t.result).has_more
)
select ((a.t)::deribit.private_get_user_trades_by_instrument_trade).*
from (
    select unnest((t.result).trades) as t
    from trades t
) a;


