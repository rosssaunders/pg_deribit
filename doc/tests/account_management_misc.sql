create extension if not exists pg_deribit cascade;

-- TODO - remove this requirement
delete from deribit.keys;
select deribit.encrypt_and_store_in_table('rvAcPbEz', 'O7p6B9IY5Ly374KG-jXMovyo3zIt0XhjMcdKTYvQENE', 'password123');
select deribit.decrypt_and_store_in_session('password123');

select *
from deribit.private_enable_affiliate_program();

-- TODO - doesn't work.
select *
from deribit.private_get_access_log(
    "offset" := 10,
    count := 10
);

-- TODO - data does match docs
select *
from deribit.private_get_affiliate_program_info();



-- todo - doesn't work
select *
from deribit.private_get_transaction_log(
    currency := 'BTC',
    start_timestamp := (extract(epoch from '2024-07-01'::timestamptz) * 1000)::bigint,
    end_timestamp := (extract(epoch from '2024-09-02'::timestamptz) * 1000)::bigint
);

select (response ->> 'body')::bytea, id
from deribit.internal_archive ia
order by ia.id desc;

--
-- select
--     (
--         convert_from((response ->> 'body')::bytea, 'utf-8')::jsonb ->> 'result'
--     )::text::jsonb
-- from deribit.internal_archive ia
-- where id = 249
-- order by ia.id desc;

select deribit.private_set_email_language(
    language := 'en'
);

select deribit.private_set_self_trading_config(
    mode := 'cancel_maker',
    extended_to_subaccounts := true
);

