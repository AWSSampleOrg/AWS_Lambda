#!/usr/bin/env bash
S3_BUCKET="your-bucket-name"
STACK_NAME="ActiveMQ-triggered-Lambda"

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

aws cloudformation package \
    --template-file template.yml \
    --s3-bucket ${S3_BUCKET} \
    --output-template-file packaged_template.yml

mq_configuration=$(aws mq list-configurations --query Configurations)

aws cloudformation deploy \
    --template-file packaged_template.yml \
    --stack-name ${STACK_NAME} \
    --parameter-overrides \
    ProjectPrefix="" \
    VpcId="" \
    PublicSubnetAId="" \
    PublicSubnetCId="" \
    EngineVersion="5.18" \
    HostInstanceType="mq.m5.xlarge" \
    MqConfigurationId="" \
    MqConfigurationRevision=1 \
    --capabilities CAPABILITY_NAMED_IAM
