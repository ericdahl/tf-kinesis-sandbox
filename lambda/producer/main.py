import json

import boto3
import os
from datetime import datetime

import logging
logging.getLogger().setLevel(logging.INFO)

client = boto3.client('kinesis')


def handler(event, context):
    logging.info("Received Event [%s]", json.dumps(event, indent=2))

    client.put_record(
        StreamName=os.environ['KINESIS_STREAM_NAME'],
        Data=datetime.now().isoformat(),
        PartitionKey='123'  # FIXME
    )