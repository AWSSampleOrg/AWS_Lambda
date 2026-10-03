#!/usr/bin/env bash
S3_BUCKET="your-bucket-name"
STACK_NAME="S3-triggered-Lambda"

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

aws cloudformation package \
    --template-file template.yml \
    --s3-bucket ${S3_BUCKET} \
    --output-template-file packaged_template.yml

if [ $(uname) = 'Darwin' ]; then
    aws cloudformation deploy \
        --template-file packaged_template.yml \
        --stack-name ${STACK_NAME} \
        --parameter-overrides \
        ProjectPrefix="" \
        BucketName=$(uuidgen) \
        --capabilities CAPABILITY_NAMED_IAM
fi
