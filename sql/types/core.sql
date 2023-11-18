create type deribit.internal_error as (
    code int,
    message text,
    data json
);

create type deribit.internal_error_response as (
    usIn bigint,
    usOut bigint,
    usDiff int,
    jsonrpc text,
    testnet bool,
    error deribit.internal_error
);
