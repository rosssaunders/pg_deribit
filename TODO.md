TODO:

Linting
- [ ] Respect all sqlfluff rules

Extension
- [ ] make a proper postgres extension

Testing files:
- [ ] auto seed data

Trading key encryption:
- [ ] Implement key encryption for trading keys

Endpoints to implement:
- [ ] deribit.public_get_delivery_prices -> expand the data to a table
- [ ] public_get_portfolio_margins'
- [ ] public_get_funding_chart_data': 'invalid documentation',
- [ ] private_get_user_trades_by_order': 'invalid documentation',
- [ ] private_cancel_all_by_kind_or_type': 'unsupported request parameter',
- [ ] private_create_api_key': 'unsupported request parameter',
- [ ] private_get_order_margin_by_ids': 'unsupported request parameter',
- [ ] public_get_funding_chart_data_response_datum
- [ ] language enums - see https://docs.deribit.com/#private-set_email_language
- [ ] all sections - sections = ['Market data', 'Account management', 'Trading', 'Wallet']
- [ ] public_get_order_book -> reformat data to a table
- 