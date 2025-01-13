import threading
import boto3

sqs = boto3.client("sqs")

def send_message(index):
    sqs.send_message(
        QueueUrl="",
        MessageBody=str(index)
    )

i = 0
while True:
    threads = [threading.Thread(target=send_message, args=(30 * i + j,)) for j in range(30)]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()
    i+=1
