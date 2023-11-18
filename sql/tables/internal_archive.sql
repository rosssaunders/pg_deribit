create table deribit.internal_archive (
    id bigint not null,
    created_at timestamptz not null default now(),
    url text not null,
    request jsonb not null,
    response jsonb null
);
