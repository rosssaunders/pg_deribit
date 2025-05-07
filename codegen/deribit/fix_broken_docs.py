import pandas as pd

# Workaround for the broken docs
def fix_broken_docs(df, end_point):
    #####################
    # tick_size_steps
    #####################
    if end_point == '/public/get_instrument' or end_point == '/public/get_instruments':
        df.at[30, 'Type'] = 'array of object'

    #####################
    # underlying_index
    #####################
    if end_point == '/public/get_order_book':
        df.at[38, 'Type'] = 'string'

    if end_point == '/public/get_order_book_by_instrument_id':
        df.at[38, 'Type'] = 'string'

    if end_point == '/public/ticker':
        df.at[38, 'Type'] = 'string'

    ###############################
    # missing result in the docs
    ###############################
    if end_point == '/private/get_user_trades_by_order':
        new_row = {
            'Name': 'result', 
            'Type': 'array of object', 
            'Description': ''
        }
        df = pd.concat([df.iloc[:2], pd.DataFrame([new_row]), df.iloc[2:]]).reset_index(drop=True)
        
        # fix the timestamp row
        df.at[3, 'Name'] = 'timestamp'
        df.at[3, 'Type'] = 'integer'
        df.at[3, 'Description'] = ''
        df.iloc[3:, 0] = (
            '› ' + df.iloc[3:, 0].astype(str)
        )
    
    #############################
    # missing fields in the docs
    #############################
    if end_point == '/private/get_account_summary':
        df.at[20, 'Type'] = 'map'
        df.at[44, 'Type'] = 'map'
        df.at[59, 'Type'] = 'map'

        # add the missing fields from the example to the end of the dataframe.
        # "delta_total_map", "estimated_liquidation_ratio_map", "estimated_liquidation_ratio"
        new_rows = [
            {'Name': '› delta_total_map', 'Type': 'map', 'Description': ''},
            {'Name': '› estimated_liquidation_ratio_map', 'Type': 'map', 'Description': ''},
            {'Name': '› estimated_liquidation_ratio', 'Type': 'float', 'Description': ''}
        ]
        df = pd.concat([df.iloc[:65], pd.DataFrame(new_rows), df.iloc[65:]]).reset_index(drop=True)

    if end_point == '/private/get_account_summaries':
        df.at[28, 'Type'] = 'map'
        df.at[45, 'Type'] = 'map'
        df.at[58, 'Type'] = 'map'

        # add the missing fields from the example to the end of the dataframe.
        # "delta_total_map", "estimated_liquidation_ratio_map", "estimated_liquidation_ratio"
        new_rows = [
            {'Name': '› › delta_total_map', 'Type': 'map', 'Description': ''},
            {'Name': '› › estimated_liquidation_ratio_map', 'Type': 'map', 'Description': ''},
            {'Name': '› › estimated_liquidation_ratio', 'Type': 'float', 'Description': ''}
        ]
        df = pd.concat([df.iloc[:63], pd.DataFrame(new_rows), df.iloc[63:]]).reset_index(drop=True)

    #############################
    # missing result field
    #############################
    if end_point == '/private/set_clearance_originator':
        # Add a result field of type boolean since this is likely a success/failure operation
        new_row = {
            'Name': 'result',
            'Type': 'boolean',
            'Description': 'Whether the clearance originator was set successfully'
        }
        # Insert at the beginning after any standard fields
        df = pd.concat([df.iloc[:2], pd.DataFrame([new_row]), df.iloc[2:]]).reset_index(drop=True)

    return df