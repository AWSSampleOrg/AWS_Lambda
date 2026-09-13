#!/usr/bin/env bash
S3_BUCKET="your-bucket-name"
LAMBDA_STACK_NAME="Lambda-with-Kafka-Cross-Account"
LAMBDA_PROFILE=''
CLUSTER_STACK_NAME="Lambda-with-Kafka-Cross-Account"
CLUSTER_PROFILE=''

TARGET_CLUSTER_ARN=$(aws cloudformation describe-stacks \
    --stack-name ${CLUSTER_STACK_NAME} \
    --query "Stacks[0].Outputs[?OutputKey=='ClusterArn'].OutputValue" \
    --profile ${CLUSTER_PROFILE} \
    --output text
)


SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

aws cloudformation package \
    --template-file template.yml \
    --s3-bucket ${S3_BUCKET} \
    --output-template-file packaged_template.yml \
    --profile ${LAMBDA_PROFILE}

aws cloudformation deploy \
    --template-file packaged_template.yml \
    --stack-name ${LAMBDA_STACK_NAME} \
    --parameter-overrides \
    VpcId= \
    PrivateSubnetAId= \
    PrivateSubnetCId= \
    TargetClusterArn=${TARGET_CLUSTER_ARN} \
    ProvisionedMode="false" \
    --capabilities CAPABILITY_NAMED_IAM  \
    --profile ${LAMBDA_PROFILE}
