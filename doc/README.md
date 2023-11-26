# Installing

```sql
create extension if not exists omni_httpc cascade;
create extension if not exists pgcrypto cascade;
create extension if not exists pg_deribit cascade;
```

# How to login for the current session.

```sql
do $$
declare
    client_id text = 'rvAcPbEz';
    client_secret text = 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA';
    password text = 'my_super_secret_password';
begin
    perform deribit.encrypt_and_store_in_table(client_id, client_secret, password);
end
$$;

do $$
declare
    password text = 'my_super_secret_password';
begin
    perform deribit.decrypt_and_store_in_session(password);
end
$$;

```

# Using a recursive CTE to paginate through all trades.

```sql
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
select (a.t).*
from (
    select unnest((t).trades) as t
    from trades t
) a;
```

