create table deribit.keys (
    id integer generated always as identity,
    client_id bytea not null,
    client_secret bytea not null,
    created_at timestamp default now()
);
