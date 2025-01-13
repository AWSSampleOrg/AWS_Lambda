import  boto3
from datetime import datetime, UTC
import json

lambda_client = boto3.client('lambda')

lambda_client.invoke(
    FunctionName='',
    Payload= json.dumps({
        "InvokedTime": datetime.now(UTC).strftime('%Y-%m-%dT%H:%M:%S.%f')
    }),
    InvocationType='Event'
)
