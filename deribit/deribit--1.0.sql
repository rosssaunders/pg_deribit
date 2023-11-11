-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION deribit" to load this file. \quit

create schema deribit;

create type deribit.error as (
    code int,
    message text,
    data json
);

create type deribit.error_response as (
    usIn bigint,
    usOut bigint,
    usDiff int,
    jsonrpc text,
    testnet bool,
    error deribit.error
);

create sequence deribit.jsonrpc_identifier;

select nextval('deribit.jsonrpc_identifier'::regclass);