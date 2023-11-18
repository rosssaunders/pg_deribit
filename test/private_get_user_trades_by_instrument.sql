with recursive trades as (
    select a.*
    from deribit.private_get_user_trades_by_instrument(
          instrument_name := 'ETH-PERPETUAL',
          count := 1,
          start_timestamp := 0,
          sorting := 'asc'
       ) a
    union all
    select b.*
    from trades t
    cross join deribit.private_get_user_trades_by_instrument(
          instrument_name := 'ETH-PERPETUAL',
          sorting := 'asc',
          count := 100,
          start_seq := (select max(v.trade_seq) from unnest((t).trades) v) + 1
             ) b
    where t.has_more
)
select ((a.t)::deribit.private_get_user_trades_by_instrument_response_trade).*
from (select unnest((t).trades) as t
      from trades t) a;




select 'text("test")'::oneormany;

select omni_types.variant('test'::text::oneormany);

select omni_types.variant(ARRAY['test', 'test2']::text[]::oneormany);

select omni_types.sum_type('oneormany', 'text', 'text[]');
create type example as
(
    id int,
    request oneormany
);
select to_json(row(1, 'test'::text::oneormany)::example);
