create function deribit.enable_test_net()
returns void
language plpgsql
as
$$
begin
    execute format('set deribit.set_test_net = ''true''');
end
$$;

create function deribit.disable_test_net()
returns void
language plpgsql
as
$$
begin
    execute format('set deribit.set_test_net = ''false''');
end
$$;
