select *
from deribit.public_get_instrument(instrument_name := 'ETH-PERPETUAL');

select
    convert_from(((deribit.internal_jsonrpc_request('/public/get_instrument', (row(
		'ETH-PERPETUAL'
    )::deribit.public_get_instrument_request)).body, 'utf-8')::jsonb;



select p.p
from deribit.public_get_index_price_names() p;

select *
from deribit.public_get_currencies();

select *
from deribit.public_get_contract_size('BTC-PERPETUAL');


