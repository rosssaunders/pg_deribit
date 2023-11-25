drop type if exists deribit.internal_error cascade;
create type deribit.internal_error as (
    code int,
    message text,
    data json
);

drop type if exists deribit.internal_error_response cascade;
create type deribit.internal_error_response as (
    usIn bigint,
    usOut bigint,
    usDiff int,
    jsonrpc text,
    testnet bool,
    error deribit.internal_error
);
