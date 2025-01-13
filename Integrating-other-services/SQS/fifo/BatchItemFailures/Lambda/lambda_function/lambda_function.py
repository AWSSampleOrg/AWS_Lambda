# -*- encoding:utf-8 -*-
import json
import logging
import os

# logger setting
logger = logging.getLogger()
logger.setLevel(os.getenv("LOG_LEVEL", logging.DEBUG))


def lambda_handler(event, context):
    logger.info(json.dumps(event))

    batch_item_failures = []
    sqs_batch_response = {}

    for record in event["Records"]:
        try:
            message_id = record['messageId']
            logger.debug(record["body"])
        except Exception as e:
            batch_item_failures.append({"itemIdentifier": message_id})
    
    sqs_batch_response["batchItemFailures"] = batch_item_failures
    return sqs_batch_response
