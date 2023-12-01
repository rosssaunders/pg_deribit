sections = ['Market data',
            'Account management',
            'Trading',
            'Wallet',
            'Authentication',
            'Session management',
            'Supporting',
            'Subscription management',
            'Combo Books'

            ]


excluded_urls = {
    'public_get_portfolio_margins': 'invalid documentation',
    'public_get_funding_chart_data': 'invalid documentation',
    'private_get_user_trades_by_order': 'invalid documentation',
    'private_cancel_all_by_kind_or_type': 'unsupported request parameter',
    'private_create_api_key': 'unsupported request parameter',
    'private_get_order_margin_by_ids': 'unsupported request parameter',
}


matching_engine_endpoints = [
    'private_buy',
    'private_sell',
    'private_edit',
    'private_edit_by_label',
    'private_cancel',
    'private_cancel_by_label',
    'private_cancel_all',
    'private_cancel_all_by_instrument',
    'private_cancel_all_by_currency',
    'private_cancel_all_by_kind_or_type',
    'private_close_position',
    'private_verify_block_trade',
    'private_execute_block_trade',
    'private_move_positions']