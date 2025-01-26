------------------------------------------------------------------------
-- Examples of how to paginate through user trades using recursive CTEs
------------------------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

select deribit.set_client_auth('<CLIENT_ID>', '<CLIENT_SECRET>');
select deribit.enable_test_net();

with recursive trades as (
    select a.*
    from deribit.private_get_user_trades_by_instrument(
        instrument_name := 'BTC-PERPETUAL',
        count := 1,
        start_timestamp := 0,
        sorting := 'asc'
    ) as a
    union all
    select b.*
    from trades as t
    cross join deribit.private_get_user_trades_by_instrument(
      instrument_name := 'BTC-PERPETUAL',
          sorting := 'asc',
          count := 100,
          start_seq := (select max(v.trade_seq) from unnest((t).trades) v) + 1
             ) as b
    where t.has_more
)
select (a.t).*
from (select unnest((t).trades) as t
      from trades as t) as a;
