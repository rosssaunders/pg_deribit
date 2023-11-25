select * 
from deribit.private_buy(
	instrument_name := 'BTC-PERPETUAL',
	amount := 0.1::numeric
);

select * 
from deribit.private_cancel(
	order_id := 19025003696
);

select * 
from deribit.private_cancel_all();

select * 
from deribit.private_cancel_all_by_currency(
	currency := 'BTC'
);

select * 
from deribit.private_cancel_all_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.private_cancel_by_label(
	label := abcde
);

select * 
from deribit.private_cancel_transfer_by_id(
	currency := 'BTC',
	id := 1
);

select * 
from deribit.private_cancel_withdrawal(
	currency := 'BTC',
	id := 1
);

select * 
from deribit.private_change_api_key_name(
	id := 1,
	name := 'test'
);

select * 
from deribit.private_change_margin_model(
	margin_model := 'cross_sm'
);

select * 
from deribit.private_change_scope_in_api_key(
	max_scope := ,
	id := 1
);

select * 
from deribit.private_change_subaccount_name(
	sid := 1,
	name := 'test'
);

select * 
from deribit.private_close_position(
	instrument_name := 'BTC-PERPETUAL',
	type := market
);

select * 
from deribit.private_create_deposit_address(
	currency := 'BTC'
);

select * 
from deribit.private_create_subaccount();

select * 
from deribit.private_disable_api_key(
	id := 1
);

select * 
from deribit.private_edit(
	order_id := 19025003696,
	amount := 0.1::numeric
);

select * 
from deribit.private_edit_by_label(
	instrument_name := 'BTC-PERPETUAL',
	amount := 0.1::numeric
);

select * 
from deribit.private_enable_affiliate_program();

select * 
from deribit.private_enable_api_key(
	id := 1
);

select * 
from deribit.private_get_access_log();

select * 
from deribit.private_get_account_summary(
	currency := 'BTC'
);

select * 
from deribit.private_get_affiliate_program_info();

select * 
from deribit.private_get_current_deposit_address(
	currency := 'BTC'
);

select * 
from deribit.private_get_deposits(
	currency := 'BTC'
);

select * 
from deribit.private_get_email_language();

select * 
from deribit.private_get_margins(
	instrument_name := 'BTC-PERPETUAL',
	amount := 0.1::numeric,
	price := 10000::numeric
);

select * 
from deribit.private_get_mmp_config();

select * 
from deribit.private_get_new_announcements();

select * 
from deribit.private_get_open_orders_by_currency(
	currency := 'BTC'
);

select * 
from deribit.private_get_open_orders_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.private_get_open_orders_by_label(
	currency := 'BTC'
);

select * 
from deribit.private_get_order_history_by_currency(
	currency := 'BTC'
);

select * 
from deribit.private_get_order_history_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.private_get_order_state(
	order_id := 19025003696
);

select * 
from deribit.private_get_order_state_by_label(
	currency := 'BTC'
);

select * 
from deribit.private_get_portfolio_margins(
	currency := 'BTC'
);

select * 
from deribit.private_get_position(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.private_get_positions(
	currency := 'BTC'
);

select * 
from deribit.private_get_settlement_history_by_currency(
	currency := 'BTC'
);

select * 
from deribit.private_get_settlement_history_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.private_get_subaccounts();

select * 
from deribit.private_get_subaccounts_details(
	currency := 'BTC'
);

select * 
from deribit.private_get_transaction_log(
	currency := 'BTC',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.private_get_transfers(
	currency := 'BTC'
);

select * 
from deribit.private_get_trigger_order_history(
	currency := 'BTC'
);

select * 
from deribit.private_get_user_locks();

select * 
from deribit.private_get_user_trades_by_currency(
	currency := 'BTC'
);

select * 
from deribit.private_get_user_trades_by_currency_and_time(
	currency := 'BTC',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.private_get_user_trades_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.private_get_user_trades_by_instrument_and_time(
	instrument_name := 'BTC-PERPETUAL',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.private_get_withdrawals(
	currency := 'BTC'
);

select * 
from deribit.private_list_api_keys();

select * 
from deribit.private_remove_api_key(
	id := 1
);

select * 
from deribit.private_remove_subaccount(
	subaccount_id := 1
);

select * 
from deribit.private_reset_api_key(
	id := 1
);

select * 
from deribit.private_reset_mmp(
	index_name := 'btc_usd'
);

select * 
from deribit.private_sell(
	instrument_name := 'BTC-PERPETUAL',
	amount := 0.1::numeric
);

select * 
from deribit.private_send_rfq(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.private_set_announcement_as_read(
	announcement_id := '1'
);

select * 
from deribit.private_set_email_for_subaccount(
	sid := 1,
	email := test@email.com
);

select * 
from deribit.private_set_email_language(
	language := 'en'
);

select * 
from deribit.private_set_mmp_config(
	index_name := 'btc_usd',
	"interval" := 1,
	frozen_time := 1
);

select * 
from deribit.private_set_self_trading_config(
	mode := ,
	extended_to_subaccounts := 
);

select * 
from deribit.private_submit_transfer_to_subaccount(
	currency := 'BTC',
	amount := 0.1::numeric,
	destination := 1
);

select * 
from deribit.private_submit_transfer_to_user(
	currency := 'BTC',
	amount := 0.1::numeric,
	destination := 1
);

select * 
from deribit.private_toggle_notifications_from_subaccount(
	sid := 1,
	state := false
);

select * 
from deribit.private_toggle_portfolio_margining(
	enabled := false
);

select * 
from deribit.private_toggle_subaccount_login(
	sid := 1,
	state := false
);

select * 
from deribit.private_withdraw(
	currency := 'BTC',
	address := 123456,
	amount := 0.1::numeric
);

select * 
from deribit.public_get_announcements();

select * 
from deribit.public_get_book_summary_by_currency(
	currency := 'BTC'
);

select * 
from deribit.public_get_book_summary_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.public_get_contract_size(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.public_get_currencies();

select * 
from deribit.public_get_delivery_prices(
	index_name := 'btc_usd'
);

select * 
from deribit.public_get_funding_rate_history(
	instrument_name := 'BTC-PERPETUAL',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.public_get_funding_rate_value(
	instrument_name := 'BTC-PERPETUAL',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.public_get_historical_volatility(
	currency := 'BTC'
);

select * 
from deribit.public_get_index(
	currency := 'BTC'
);

select * 
from deribit.public_get_index_price(
	index_name := 'btc_usd'
);

select * 
from deribit.public_get_index_price_names();

select * 
from deribit.public_get_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.public_get_instruments(
	currency := 'BTC'
);

select * 
from deribit.public_get_last_settlements_by_currency(
	currency := 'BTC'
);

select * 
from deribit.public_get_last_settlements_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.public_get_last_trades_by_currency(
	currency := 'BTC'
);

select * 
from deribit.public_get_last_trades_by_currency_and_time(
	currency := 'BTC',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.public_get_last_trades_by_instrument(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.public_get_last_trades_by_instrument_and_time(
	instrument_name := 'BTC-PERPETUAL',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.public_get_mark_price_history(
	instrument_name := 'BTC-PERPETUAL',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164
);

select * 
from deribit.public_get_order_book(
	instrument_name := 'BTC-PERPETUAL'
);

select * 
from deribit.public_get_order_book_by_instrument_id(
	instrument_id := 124972
);

select * 
from deribit.public_get_rfqs(
	currency := 'BTC'
);

select * 
from deribit.public_get_supported_index_names();

select * 
from deribit.public_get_trade_volumes();

select * 
from deribit.public_get_tradingview_chart_data(
	instrument_name := 'BTC-PERPETUAL',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164,
	resolution := '1D'
);

select * 
from deribit.public_get_volatility_index_data(
	currency := 'BTC',
	start_timestamp := 1700319764,
	end_timestamp := 1700406164,
	resolution := '1D'
);

select * 
from deribit.public_ticker(
	instrument_name := 'BTC-PERPETUAL'
);

