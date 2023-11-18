--
-- select ((bids))
-- from deribit.public_get_order_book_by_instrument_id(124942::bigint, '100'::deribit.public_get_order_book_by_instrument_id_request_depth);

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
    order by x desc
),
asks as (
    select x, row_number() over () as rn
    from (
        select x, row_number() over () rn
        from (
            select unnest(asks)
            from ob
        ) x
    ) y
    where rn % 2 != 0
    order by x
)
select b.x as bid, a.x as ask
from bids b
full outer join asks a on b.rn = a.rn;