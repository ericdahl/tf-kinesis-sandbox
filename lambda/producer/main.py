import json

import boto3
import os
from datetime import datetime
import random

import logging
logging.getLogger().setLevel(logging.INFO)

client = boto3.client('kinesis')


def handler(event, context):
    logging.debug("Received Event [%s]", json.dumps(event, indent=2))

    client.put_record(
        StreamName=os.environ['KINESIS_STREAM_NAME'],
        Data=os.environ["LAMBDA_ID"] + "/" + datetime.now().isoformat() + "\n",
        PartitionKey=str(random.randrange(100))
    )