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

    if event['isFinalInvokeForWindow']:
        logger.debug('FinalInvokeForWindow')
    else:
        logger.debug('Aggregate invoke')

    if event['isWindowTerminatedEarly']:
        logger.debug('WindowTerminatedEarly')

    state = event['state']
    for record in event['Records']:
        state[record['kinesis']['partitionKey']] = state.get(record['kinesis']['partitionKey'], 0) + 1

    logger.info('Returning state: ', state)
    return {'state': state}
