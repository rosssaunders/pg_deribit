import json
import logging
import os
import sys
from deribit.consts import sections
from deribit.openapi_parser import (
    load_endpoints_from_openapi,
    load_endpoints_from_snapshot,
)
from postgres.exporter import Exporter
from utils.json_utils import CustomJSONizer

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

schema = "deribit"


def cleanup_endpoints():
    """Clean up old endpoint files before generating new ones."""
    endpoints_dir = os.path.join(os.path.dirname(__file__), "..", "sql", "endpoints")
    if os.path.exists(endpoints_dir):
        logger.info("Cleaning up old endpoint files...")
        for file in os.listdir(endpoints_dir):
            if file.endswith(".sql"):
                os.remove(os.path.join(endpoints_dir, file))
        logger.info("Cleanup complete")


def main():
    os.chdir(sys.path[0])

    # Clean up old endpoint files first
    cleanup_endpoints()

    exporter = Exporter()
    exporter.set_schema(schema)

    exporter.setup()
    snapshot_path = "deribit.json"
    use_snapshot = os.path.isfile(snapshot_path)
    if use_snapshot:
        logger.info("Loading endpoints from %s for stable output", snapshot_path)
        endpoints = load_endpoints_from_snapshot(snapshot_path)
    else:
        endpoints = load_endpoints_from_openapi(sections)

    if not use_snapshot:
        # export all functions to json
        # Use json.dumps() to convert the object to a JSON string
        endpoint_dict = [endpoint.to_dict() for endpoint in endpoints]
        my_json = json.dumps(endpoint_dict, indent=4, sort_keys=True, cls=CustomJSONizer)

        with open("deribit.json", "w") as json_file:
            json_file.write(my_json)
    else:
        logger.info("Snapshot mode active; skipping deribit.json rewrite")

    # now codegen the wrapper functions
    exporter.all(endpoints)


if __name__ == "__main__":
    main()
