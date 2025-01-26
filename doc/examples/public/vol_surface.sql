-----------------------------------------------------------------------
-- An example of how to created an implied volatility surface
-- with some very crude adjustments for the volatility smile
-----------------------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

with book_summary as (
    select mark_iv, instrument_name
    from deribit.public_get_book_summary_by_currency('BTC') as b
    where mark_iv > 0
),
all_options as (
    select strike, expiration_timestamp, instrument_name
    from deribit.public_get_instruments(
            currency := 'BTC',
            kind := 'option',
            expired := 'false'::boolean)
    where option_type = 'call'
),
option_chain as (
    select
        strike,
        to_timestamp(expiration_timestamp / 1000)::timestamptz as maturity,
        mark_iv as iv
    from book_summary as s
    inner join all_options as o on s.instrument_name = o.instrument_name
),
cte as (
    select
        maturity,
        strike,
        iv,
        lead(iv) over (partition by maturity order by strike) as iv_plus,
        lag(iv) over (partition by maturity order by strike) as iv_minus
    from option_chain
),
adjusted as (
    select
        maturity,
        strike,
        case
            when (coalesce(iv_minus, iv) - 2*iv + coalesce(iv_plus, iv)) < 0
                then (coalesce(iv_minus, iv) + coalesce(iv_plus, iv)) / 2.0
            else iv
        end as iv_corrected
    from cte
)
select maturity, strike, iv_corrected::numeric(24, 2) as iv
from adjusted
order by maturity, strike;
