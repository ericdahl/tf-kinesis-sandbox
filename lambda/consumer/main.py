import json
import base64

import logging
logging.getLogger().setLevel(logging.INFO)


def handler(event, context):
    logging.info("Received Event [%s]", json.dumps(event, indent=2))

    for r in event['Records']:
        d = base64.b64decode(r['kinesis']['data'])

        logging.info("Got Record [%s]", d)

