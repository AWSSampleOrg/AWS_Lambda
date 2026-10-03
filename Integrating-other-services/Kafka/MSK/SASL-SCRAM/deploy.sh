#!/usr/bin/env bash
S3_BUCKET="your-bucket-name"
STACK_NAME="Lambda-with-Kafka-SCRAM"

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

aws cloudformation package \
    --template-file template.yml \
    --s3-bucket ${S3_BUCKET} \
    --output-template-file packaged_template.yml

function deploy(){
    aws cloudformation deploy \
        --template-file packaged_template.yml \
        --stack-name ${STACK_NAME} \
        --parameter-overrides \
        VpcId= \
        PrivateSubnetAId= \
        PrivateSubnetCId= \
        EsmEnabled=$1 \
        --capabilities CAPABILITY_NAMED_IAM
}

deploy false

msk_cluster_arn=$(
    aws cloudformation describe-stacks \
        --stack-name ${STACK_NAME} \
        --query "Stacks[0].Outputs[?OutputKey=='MSKClusterArn'].OutputValue" \
        --output text
)
aws kafka create-topic \
    --cluster-arn ${msk_cluster_arn} \
    --topic-name MSKTutorialTopic \
    --partition-count 3 \
    --replication-factor 2

deploy true
