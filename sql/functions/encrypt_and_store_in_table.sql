create function deribit.encrypt_and_store_in_table(client_id text, client_secret text, encryption_password text)
returns void
language plpgsql
as
$$
declare
    encrypted_client_id bytea;
    encrypted_client_secret bytea;
begin
    -- Encrypt the value
    encrypted_client_id := pgp_sym_encrypt(client_id, encryption_password);
    encrypted_client_secret := pgp_sym_encrypt(client_secret, encryption_password);

    insert into deribit.keys (client_id, client_secret) values (encrypted_client_id, encrypted_client_secret);
end;
$$;
