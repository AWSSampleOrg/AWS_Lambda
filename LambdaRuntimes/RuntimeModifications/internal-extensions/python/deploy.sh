#!/usr/bin/env bash
S3_BUCKET="your-bucket-name"
STACK_NAME="Lambda-with-Wrapper-based-Internal-Extension"

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

chmod +x bin/importtime_wrapper
zip -r internal-extension.zip bin/importtime_wrapper
aws s3 cp internal-extension.zip s3://${S3_BUCKET}/internal-extension.zip

aws cloudformation package \
    --template-file template.yml \
    --s3-bucket ${S3_BUCKET} \
    --output-template-file packaged_template.yml

aws cloudformation deploy \
    --template-file packaged_template.yml \
    --stack-name ${STACK_NAME} \
    --parameter-overrides \
    ProjectPrefix="" \
    --capabilities CAPABILITY_NAMED_IAM
