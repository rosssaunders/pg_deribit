-----------------------------------------------------------------------
-- An example of how to create a modeled implied volatility surface.
-- Fits a quadratic smile in log-moneyness per expiry, then smooths
-- coefficients across neighboring maturities.
--
-- Usage (psql):
-- \i doc/examples/public/vol_surface.sql
--
-- Output:
-- maturity | strike | iv
-----------------------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

drop view if exists temp_vol_surface;

create temporary view temp_vol_surface as
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
index_price as (
    select (deribit.public_get_index_price('btc_usd')).index_price as spot_price
),
with_moneyness as (
    select
        maturity,
        strike,
        iv,
        ln(strike / spot_price) as log_moneyness
    from option_chain
    cross join index_price
),
moments as (
    select
        maturity,
        count(*)::double precision as n,
        sum(log_moneyness)::double precision as s1,
        sum(power(log_moneyness, 2))::double precision as s2,
        sum(power(log_moneyness, 3))::double precision as s3,
        sum(power(log_moneyness, 4))::double precision as s4,
        sum(iv)::double precision as t0,
        sum(log_moneyness * iv)::double precision as t1,
        sum(power(log_moneyness, 2) * iv)::double precision as t2
    from with_moneyness
    group by maturity
),
coefficients as (
    select
        maturity,
        s0,
        s1,
        s2,
        s3,
        s4,
        t0,
        t1,
        t2,
        (s0 * (s2 * s4 - s3 * s3) - s1 * (s1 * s4 - s2 * s3) + s2 * (s1 * s3 - s2 * s2)) as d,
        (t0 * (s2 * s4 - s3 * s3) - s1 * (t1 * s4 - s3 * t2) + s2 * (t1 * s3 - s2 * t2)) as da,
        (s0 * (t1 * s4 - s3 * t2) - t0 * (s1 * s4 - s3 * s2) + s2 * (s1 * t2 - t1 * s2)) as db,
        (s0 * (s2 * t2 - t1 * s3) - s1 * (s1 * t2 - t1 * s2) + t0 * (s1 * s3 - s2 * s2)) as dc
    from (
        select
            maturity,
            n as s0,
            s1, s2, s3, s4,
            t0, t1, t2
        from moments
    ) as m
),
fit as (
    select
        maturity,
        case when d = 0 then null else da / d end as a,
        case when d = 0 then null else db / d end as b,
        case when d = 0 then null else dc / d end as c
    from coefficients
),
smoothed_fit as (
    select
        maturity,
        avg(a) over w as a,
        avg(b) over w as b,
        avg(c) over w as c
    from fit
    window w as (
        order by maturity
        rows between 1 preceding and 1 following
    )
),
modeled as (
    select
        w.maturity,
        w.strike,
        w.log_moneyness,
        greatest(0.0001, (f.a + f.b * w.log_moneyness + f.c * power(w.log_moneyness, 2))) as iv_modeled
    from with_moneyness as w
    inner join smoothed_fit as f on w.maturity = f.maturity
)
select maturity, strike, log_moneyness, iv_modeled
from modeled;

select maturity, strike, iv_modeled::numeric(24, 2) as iv
from temp_vol_surface
order by maturity, strike;
