# -*- encoding:utf-8 -*-
import json
import logging
import os

# logger setting
logger = logging.getLogger()
logger.setLevel(os.getenv("LOG_LEVEL", logging.DEBUG))


def lambda_handler(event, context):
    logger.info(json.dumps(event))

    for record in event["Records"]:
        sequence_number = record["dynamodb"]["SequenceNumber"]

        if record["eventName"] == "INSERT":
            new_image = record["dynamodb"]["NewImage"]
        elif record["eventName"] == "MODIFY":
            old_image = record["dynamodb"]["OldImage"]
            new_image = record["dynamodb"]["NewImage"]
        elif record["eventName"] == "REMOVE":
            old_image = record["dynamodb"]["OldImage"]
