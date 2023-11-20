select *
from (
    with vs as (
        select (
                (jsonb_populate_record(
                        null::deribit.public_get_historical_volatility_response,
                        convert_from((deribit.internal_jsonrpc_request('/public/get_historical_volatility', row (
                            'BTC'
                            )::deribit.public_get_historical_volatility_request)).body, 'utf-8')::jsonb)
                    ))
    )
    select *
    from vs
--     select
--         (
--             to_timestamp((vs.unnest_2d_1d::double precision[])[1] / 1000),
--             (vs.unnest_2d_1d::double precision[])[2]
--         )::vol3 as vol_point
--     from vs
) a;

return query (
    select *
    from unnest(
         (jsonb_populate_record(
                    null::deribit.public_get_historical_volatility_response,
                    convert_from(_http_response.body, 'utf-8')::jsonb)
         ).result)
);

with elements as (
    select jsonb_array_elements('[[1549720800000, 14.747743607344217], [1549720800000, 14.747743607344217]]'::jsonb) x
)
select x -> 0, x -> 1
from elements;





        # as r



with x as (
    select convert_from((deribit.internal_jsonrpc_request('/public/get_historical_volatility',
  row('BTC')::deribit.public_get_historical_volatility_request)).body, 'utf-8')::jsonb -> 'result' as r
)
select *
from deribit.convert_from_jsonb_array_to_table(x.r);




drop function deribit.convert_from_jsonb_array_to_table(jsonb);
create function deribit.convert_from_jsonb_array_to_table(_jsonb_array jsonb)
returns jsonb
as $$
    with x as (select jsonb_array_elements(_jsonb_array) items)
    select
        json_agg(json_build_object(
            'timestamp', to_timestamp((items -> 0)::bigint / 1000),
            'volatility', items -> 1
        ))
    from x;
$$ language sql;

select
    deribit.convert_from_jsonb_array_to_table(
convert_from(
    (deribit.internal_jsonrpc_request('/public/get_historical_volatility',
    row('BTC')::deribit.public_get_historical_volatility_request
    )).body, 'utf-8')::jsonb -> 'result'
);

select jsonb_populate_recordset(
            null::deribit.public_get_historical_volatility_response,
            convert_from((deribit.internal_jsonrpc_request('/public/get_historical_volatility', row (
                'BTC'
            )::deribit.public_get_historical_volatility_request)).body, 'utf-8')::jsonb)
    ));

select
    deribit.convert_from_jsonb_array_to_table(
convert_from(
    (deribit.internal_jsonrpc_request('/public/get_historical_volatility',
    row('BTC')::deribit.public_get_historical_volatility_request
    )).body, 'utf-8')::jsonb -> 'result'
);

drop type if exists deribit.public_get_historical_volatility_response cascade;
create type deribit.public_get_historical_volatility_response as
(
    id      bigint,
    jsonrpc text,
    result  double precision[][]
);

select deribit.unnest_2d_1d((
    (jsonb_populate_record(
            null::deribit.public_get_historical_volatility_response,
            convert_from((deribit.internal_jsonrpc_request('/public/get_historical_volatility', row (
                'BTC'
                )::deribit.public_get_historical_volatility_request)).body, 'utf-8')::jsonb)
        )).result);

create function derbit.unpack_vol_history(values double precision[][])
returns setof deribit.vol3
as
$$
    select
        to_timestamp((unnest_2d_1d::double precision[])[1] / 1000),
        (unnest_2d_1d::double precision[])[2]
    from unnest(values) unnest_2d_1d
$$ language sql;











