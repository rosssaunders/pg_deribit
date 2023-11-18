with args as (
    select
        'ETH-PERPETUAL' as instrument_name,
        '100'::deribit.public_get_order_book_request_depth as depth
),
asks as (
    select
        round((deribit.unnest_2d_1d(asks))[1]) as price,
        (deribit.unnest_2d_1d(asks))[2] as amount
    from args
    cross join deribit.public_get_order_book(args.instrument_name, args.depth)
)
select
    'ask' as side,
    price,
    sum(amount) as amount
from asks
group by price
order by price;
