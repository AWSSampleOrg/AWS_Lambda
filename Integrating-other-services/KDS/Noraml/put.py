import threading
import boto3

kinesis = boto3.client("kinesis")

def put_record(index):
    kinesis.put_record(
        StreamName="stream",
        PartitionKey=str(index),
        Data=str(index)
    )

i = 0
while True:
    threads = [threading.Thread(target=put_record, args=(30 * i + j,)) for j in range(30)]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()
    i+=1
