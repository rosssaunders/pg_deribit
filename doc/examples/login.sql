do $$
declare
    client_id text = 'rvAcPbEz';
    client_secret text = 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA';
    password text = 'my_super_secret_password';
begin
    perform deribit.encrypt_and_store_in_table(client_id, client_secret, password);
end
$$;

do $$
declare
    password text = 'my_super_secret_password';
begin
    perform deribit.decrypt_and_store_in_session(password);
end
$$;
