import json
import base64

def handler(event, context):
    print("Received event...: " + json.dumps(event, indent=2))

    print("num records: " + str(len(event['Records'])))

    for r in event['Records']:
        d = base64.b64decode(r['kinesis']['data'])

        print(f"got record: {d}")
