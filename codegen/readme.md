# Codegen

This is a tool to generate the sql/endpoints folder from the Deribit OpenAPI specs.

## Description

The Python script downloads the OpenAPI specs and converts them into an
intermediate JSON format (`deribit.json`), then generates the sql/endpoints
folder.

Each endpoint is saved as a separate sql file in the sql/endpoints folder.

## How to generate the SQL code wrappers from the OpenAPI specs

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

## OpenAPI Notes

Some request parameters are documented as JSON strings rather than structured
schemas. The generator preserves these as `jsonb` in Postgres to keep payloads
round-trippable.
