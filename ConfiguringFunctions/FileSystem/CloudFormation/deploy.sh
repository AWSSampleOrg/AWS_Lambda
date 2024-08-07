#!/usr/bin/env bash
STACK_NAME="Lambda-with-EFS"

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

aws cloudformation deploy \
    --template-file efs.yml \
    --stack-name ${STACK_NAME} \
    --parameter-overrides \
    VpcId= \
    PrivateSubnetAID= \
    PrivateSubnetBID= \
    PrivateSubnetCID= \
    PrivateSubnetDID= \
    --capabilities CAPABILITY_NAMED_IAM
