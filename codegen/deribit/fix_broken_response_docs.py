import logging

import pandas as pd

logger = logging.getLogger(__name__)


def fix_broken_docs(df, end_point):
    """
    Workaround for incorrect Deribit API documentation structures.

    This function corrects known issues in the API documentation before
    code generation. Currently handles tick_size_steps structure.
    """
    #####################
    # tick_size_steps
    #####################
    if end_point == "/public/get_instrument" or end_point == "/public/get_instruments":
        # Find the row containing tick_size_steps
        tick_size_steps_idx = None
        for idx in range(len(df)):
            if pd.notna(df.iloc[idx, 0]) and "tick_size_steps" in str(df.iloc[idx, 0]):
                tick_size_steps_idx = idx
                break

        if tick_size_steps_idx is None:
            logger.warning(f"Could not find tick_size_steps in {end_point}")
            return df

        # Fix the type of tick_size_steps to be array of object
        df.at[tick_size_steps_idx, "Type"] = "array of object"

        # The docs incorrectly show:
        #   tick_size_steps (object)
        #     › above_price (array)
        #       ›› tick_size (number)
        # But the API actually returns:
        #   tick_size_steps: [{tick_size: number, above_price: number}]
        #
        # Drop all nested rows under tick_size_steps
        # Count the indentation level of tick_size_steps
        tick_size_steps_name = str(df.iloc[tick_size_steps_idx, 0])
        tick_size_steps_level = tick_size_steps_name.count("›")

        rows_to_drop = []
        for idx in range(tick_size_steps_idx + 1, len(df)):
            row_name = str(df.iloc[idx, 0])
            if pd.isna(df.iloc[idx, 0]) or not row_name.startswith("›"):
                break  # No more nested rows
            row_level = row_name.count("›")
            if row_level > tick_size_steps_level:
                rows_to_drop.append(idx)
            else:
                break  # Back to same level or less, stop

        if rows_to_drop:
            df = df.drop(rows_to_drop).reset_index(drop=True)

        # Now insert the correct fields as new rows after tick_size_steps
        new_rows = pd.DataFrame(
            [
                {
                    "Name": "› " * (tick_size_steps_level + 1) + "tick_size",
                    "Type": "number",
                    "Description": "Tick size to be used above the price. It must be multiple of the minimum tick size.",
                },
                {
                    "Name": "› " * (tick_size_steps_level + 1) + "above_price",
                    "Type": "number",
                    "Description": "The price from which the increased tick size applies",
                },
            ]
        )

        df = pd.concat(
            [
                df.iloc[: tick_size_steps_idx + 1],
                new_rows,
                df.iloc[tick_size_steps_idx + 1 :],
            ]
        ).reset_index(drop=True)

    #####################
    # underlying_index
    #####################
    if end_point == "/public/get_order_book":
        df.at[38, "Type"] = "string"

    if end_point == "/public/get_order_book_by_instrument_id":
        df.at[38, "Type"] = "string"

    if end_point == "/public/ticker":
        df.at[38, "Type"] = "string"

    ###############################
    # missing result in the docs
    ###############################
    if end_point == "/private/get_user_trades_by_order":
        # Update the existing row instead of inserting a new one
        df.loc[df["Name"] == "array of", "Name"] = "result"
        df.loc[df["Name"] == "result", "Type"] = "array of object"
        df.loc[df["Name"] == "result", "Description"] = ""

        # fix the missing indentation for all the rows
        df.iloc[3:, 0] = "› " + df.iloc[3:, 0].astype(str)

    #############################
    # missing result field
    #############################
    if end_point == "/private/set_clearance_originator":
        # Add a result field of type boolean since this is likely a success/failure operation
        new_row = {
            "Name": "result",
            "Type": "boolean",
            "Description": "Whether the clearance originator was set successfully",
        }
        # Insert at the beginning after any standard fields
        df = pd.concat([df.iloc[:2], pd.DataFrame([new_row]), df.iloc[2:]]).reset_index(
            drop=True
        )

    return df
