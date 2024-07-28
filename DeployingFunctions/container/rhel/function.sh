#!/bin/bash

function handler() {
    EVENT_DATA=$1

    echo ${EVENT_DATA} 1>&2

    RESPONSE="{\"statusCode\": 200, \"body\": \"Hello from Lambda!\"}"
    echo $RESPONSE
}
