drop table if exists deribit.keys;
create table deribit.keys (
    id integer generated always as identity,
    key_name varchar(255) not null,
    secret varchar(255) not null,
    created_at timestamp default now()
);
