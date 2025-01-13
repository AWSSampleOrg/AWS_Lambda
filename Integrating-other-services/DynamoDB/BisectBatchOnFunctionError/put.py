import threading
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("table")

def put_item(index):
    table.put_item(
        Item={
            "id": str(index)
        }
    )

i = 0
while True:
    threads = [threading.Thread(target=put_item, args=(30 * i + j,)) for j in range(30)]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()
    i+=1
