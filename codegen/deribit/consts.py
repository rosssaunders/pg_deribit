sections = [
    'Authentication',
    'Session management',
    'Supporting',
    'Subscription management',
    'Market data',
    'Trading',
    'Combo Books',
    'Block Trade',
    'Wallet',
    'Account management'
]

excluded_urls = {
    'private_mass_quote': 'This endpoint can only be used after approval from the administrators.',
    'public_hello': 'Websocket only',
    'public_set_heartbeat': 'Websocket only',
    'public_disable_heartbeat': 'Websocket only',
    'public_get_portfolio_margins': 'Deprecated', #https://docs.deribit.com/#public-get_portfolio_margins
    'private_get_portfolio_margins': 'Deprecated', #https://docs.deribit.com/?javascript#private-get_portfolio_margins
    'public_get_index': 'Deprecated' # https://docs.deribit.com/#public-get_index
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
    'private_move_positions',
    'private_mass_quote'
]
