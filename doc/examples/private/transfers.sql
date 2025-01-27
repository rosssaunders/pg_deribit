------------------------------------------------------------------------
-- Examples of how to call to place orders using generate_series
------------------------------------------------------------------------
create extension if not exists pg_deribit cascade; --noqa:PRS

select deribit.set_client_auth('<CLIENT_ID>', '<CLIENT_SECRET>');
select deribit.enable_test_net();

------------------------------------------------------------
-- Example of retrieving all deposits since the beginning
------------------------------------------------------------
with currencies as (
    select unnest(enum_range(null::deribit.private_get_transfers_request_currency)) as code
),
paginated_transfer as (
    select
        d.*
    from currencies as c
    inner join lateral (
        with recursive recursive_transfers as (
            select
                *,
                0 as current_offset
            from deribit.private_get_transfers(
                currency := c.code,
                "offset" := 0,
                count := 1000
            )
            union all
            select
                d.*,
                rd.current_offset + 1 as current_offset
            from recursive_transfers as rd
            inner join lateral deribit.private_get_transfers(
                currency := c.code,
                "offset" := rd.current_offset + 1000,
                count := 1000
            ) as d on true
            where array_length(d.data, 1) is not null
        )
        select *
        from recursive_transfers
    ) as d on true
)
select (unnest(data)).*
from paginated_transfer;
