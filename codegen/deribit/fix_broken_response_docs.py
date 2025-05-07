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
        # Update the existing row instead of inserting a new one
        df.loc[df['Name'] == 'array of', 'Name'] = 'result'
        df.loc[df['Name'] == 'result', 'Type'] = 'array of object'
        df.loc[df['Name'] == 'result', 'Description'] = ''
        
        # fix the missing indentation for all the rows
        df.iloc[3:, 0] = (
            '› ' + df.iloc[3:, 0].astype(str)
        )
    
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