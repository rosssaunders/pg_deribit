create or replace function deribit.join_paths(variadic paths text[])
    returns text as
$$
declare
    result text = '';
    path   text;
begin
    for i in 1..array_length(paths, 1)
        loop
            path := paths[i];
            result := result || '/' || regexp_replace(path, '^/|/$', '', 'g');
        end loop;

    return result;
end;
$$ language plpgsql;
