/*
* AUTO-GENERATED FILE - DO NOT MODIFY
*
* This SQL file was generated by a code generation tool. Any modifications
* made to this file may be overwritten by subsequent code generation
* processes and could lead to inconsistencies or errors in the application.
*
* For any required changes, please modify the source templates or the
* code generation tool's configurations and regenerate this file.
*
* WARNING: MODIFYING THIS FILE DIRECTLY CAN LEAD TO UNEXPECTED BEHAVIOR
* AND IS STRONGLY DISCOURAGED.
*/
drop type if exists deribit.public_auth_request_grant_type cascade;

create type deribit.public_auth_request_grant_type as enum (
    'client_credentials',
    'client_signature',
    'refresh_token'
);

drop type if exists deribit.public_auth_request cascade;

create type deribit.public_auth_request as (
    grant_type deribit.public_auth_request_grant_type,
    client_id text,
    client_secret text,
    refresh_token text,
    "timestamp" bigint,
    signature text,
    nonce text,
    data text,
    state text,
    scope text
);

comment on column deribit.public_auth_request.grant_type is '(Required) Method of authentication';
comment on column deribit.public_auth_request.client_id is '(Required) Required for grant type client_credentials and client_signature';
comment on column deribit.public_auth_request.client_secret is '(Required) Required for grant type client_credentials';
comment on column deribit.public_auth_request.refresh_token is '(Required) Required for grant type refresh_token';
comment on column deribit.public_auth_request."timestamp" is '(Required) Required for grant type client_signature, provides time when request has been generated (milliseconds since the UNIX epoch)';
comment on column deribit.public_auth_request.signature is '(Required) Required for grant type client_signature; it''s a cryptographic signature calculated over provided fields using user secret key. The signature should be calculated as an HMAC (Hash-based Message Authentication Code) with SHA256 hash algorithm';
comment on column deribit.public_auth_request.nonce is 'Optional for grant type client_signature; delivers user generated initialization vector for the server token';
comment on column deribit.public_auth_request.data is 'Optional for grant type client_signature; contains any user specific value';
comment on column deribit.public_auth_request.state is 'Will be passed back in the response';
comment on column deribit.public_auth_request.scope is 'Describes type of the access for assigned token, possible values: connection, session:name, trade:[read, read_write, none], wallet:[read, read_write, none], account:[read, read_write, none], expires:NUMBER, ip:ADDR. Details are elucidated in Access scope';
