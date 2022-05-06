import json

import boto3
from datetime import datetime
import os

client = boto3.client('kinesis')


def handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))


    client.put_record(
        StreamName=os.environ['KINESIS_STREAM_NAME']
        Data=datetime.now().isoformat(),
        PartitionKey='123' # FIXME
    )

