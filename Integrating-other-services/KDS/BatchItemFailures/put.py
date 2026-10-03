import boto3

kinesis = boto3.client("kinesis")
kinesis.put_records(
    StreamName="stream",
    Records=[
        { "Data": data, "PartitionKey": data } for data in ["0", "1", "c", "3"]
    ]
)
