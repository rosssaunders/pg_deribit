# Codegen

This is a tool to generate the sql/endpoints folder from the Deribit API.

## Description

The python script downloads the Deribit API documentation (if not already downloaded) and then parses it to generate the sql/endpoints folder.

It first parses the HTML docs and converts them into an intermediate JSON format which is saved as deribit.json.

Then it parses the JSON and generates the sql/endpoints folder.

Each endpoint is saved as a separate sql file in the sql/endpoints folder.

## How to generate the SQL code wrappers from the Deribit HTML documentation

From the root of the repo, run the following commands:

For PowerShell:
```PowerShell
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
cd codegen
python main.py
```

For Bash:
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd codegen
python main.py
```

## Deribit Documentation Errors

The Deribit documentation has a few errors that need to be worked around.

The `fix_broken_docs.py` script contains the code to work around these errors.

Once this errors have been fixed in the Deribit documentation, the `fix_broken_docs.py` script can be modified and removed.
