# -*- encoding:utf-8 -*-
import json
import logging
import os
import base64

# logger setting
logger = logging.getLogger()
logger.setLevel(os.getenv("LOG_LEVEL", logging.DEBUG))


def lambda_handler(event, context):
    logger.info(json.dumps(event))

    for record in event['Records']:
        try:
            # Process your record
            sequence_number = record["kinesis"]["sequenceNumber"]

            payload = base64.b64decode(record["kinesis"]["data"]).decode()
            logger.debug(payload)

        except Exception as e:
            # Return failed record's sequence number
            return {"batchItemFailures":[{"itemIdentifier": sequence_number}]}

    return {"batchItemFailures":[]}
