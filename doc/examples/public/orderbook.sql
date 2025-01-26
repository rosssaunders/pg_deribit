-----------------------------------------------------------
-- An example of how to get the live order book and show
-- the bids and asks stacked like the UI
-----------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

with req as (
    select
        'BTC-PERPETUAL' as symbol,
        '10'::deribit.public_get_order_book_request_depth as depth
),
sides as (
    select
        deribit.unnest_2d_1d(bids) as bids,
        deribit.unnest_2d_1d(asks) as asks
    from req, deribit.public_get_order_book(symbol, depth)
),
bids as (
    select
        'bid' as side, 
        bids[1] as price, 
        bids[2] as amount
    from sides
),
asks as (
    select
        'ask' as side,
        asks[1] as price,
        asks[2] as amount
    from sides
)
select
    side,
    price,
    amount
from bids
union all
select
    side,
    price,
    amount
from asks
order by 1, 2 desc;
