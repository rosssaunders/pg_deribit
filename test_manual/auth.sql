
select encrypt_and_store_in_table('rvAcPbEz', 'DRpl1FiW_nvsyRjnifD4GIFWYPNdZlx79qmfu-H6DdA', 'password12345');
select *
from deribit.keys;

select decrypt_and_store_in_session('password12345');

select pgp_sym_decrypt((select client_id from deribit.keys limit 1), 'password12345');
select pgp_sym_decrypt((select client_secret from deribit.keys limit 1), 'password12345');
