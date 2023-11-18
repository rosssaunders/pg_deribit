with ob as (
    select bids, asks
    from deribit.public_get_order_book_by_instrument_id(124942::bigint, '100'::deribit.public_get_order_book_by_instrument_id_request_depth)
),
bids as (
    select x, row_number() over () as rn
    from (
        select x, row_number() over () rn
        from (
            select unnest(bids)
            from ob
        ) x
    ) y
    where rn % 2 != 0
    order by rn asc
    limit 5
),
asks as (
    select x, rn
    from (
        select x, row_number() over () rn
        from (
            select unnest(asks)
            from ob
        ) x
    )
    where rn % 2 != 0
    limit 5
)
select 'best_' || side || '_' || row_number() over (partition by side order by rn) as rn, x
from
(
    select 'ask' as side, a.x, a.rn
    from asks a
    union
    select 'bid' as side, b.x, b.rn
    from bids b
) a
order by side, case when side = 'ask' then rn * -1 else rn end;

