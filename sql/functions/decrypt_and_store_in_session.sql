create function deribit.decrypt_and_store_in_session(decryption_key text)
returns void
language plpgsql
as
$$
declare
    decrypted_client_id bytea;
    decrypted_client_secret bytea;
begin
    -- Decrypt the text
    decrypted_client_id := pgp_sym_decrypt((select client_id from deribit.keys), decryption_key);
    decrypted_client_secret := pgp_sym_decrypt((select client_secret from deribit.keys), decryption_key);

    -- Store the decrypted text in a session variable
    execute format('set deribit.client_id = ''%s''', convert_from(decrypted_client_id, 'utf8'));
    execute format('set deribit.client_secret = ''%s''', convert_from(decrypted_client_secret, 'utf8'));
end
$$;
