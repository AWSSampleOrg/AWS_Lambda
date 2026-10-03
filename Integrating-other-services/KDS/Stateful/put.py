import boto3
import time

kinesis = boto3.client("kinesis")

def put_record(index):
    kinesis.put_record(
        StreamName="stream",
        PartitionKey="1",
        Data=str(index)
    )

for i in range(30):
    put_record(i)
    time.sleep(1)
    print(i)
