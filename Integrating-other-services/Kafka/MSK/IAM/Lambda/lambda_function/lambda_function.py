# -*- encoding:utf-8 -*-
import base64
import logging
import os
import json

# logger setting
logger = logging.getLogger()
logger.setLevel(os.getenv("LOG_LEVEL", logging.DEBUG))

def lambda_handler(event, context):
    logger.info(json.dumps(event))

    for key in event['records']:
        logger.debug(f'Key: {key}')

        for record in event['records'][key]:
            msg = base64.b64decode(record['value']).decode('utf-8')
            logger.debug(msg)
