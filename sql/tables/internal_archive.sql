create table deribit.internal_archive (
    id bigint not null,
    created_at timestamptz not null default now(),
    url deribit.endpoint not null,
    request jsonb not null,
    response jsonb null
);

comment on table deribit.internal_archive is 'Internal archive of deribit API requests and responses';
