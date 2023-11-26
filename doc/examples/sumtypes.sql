
select 'text("test")'::oneormany;

select omni_types.variant('test'::text::oneormany);

select omni_types.variant(ARRAY['test', 'test2']::text[]::oneormany);

select omni_types.sum_type('oneormany', 'text', 'text[]');
create type example as
(
    id int,
    request oneormany
);
select to_json(row(1, 'test'::text::oneormany)::example);
