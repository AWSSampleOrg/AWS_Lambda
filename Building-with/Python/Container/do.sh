#!/usr/bin/env bash
profile='default'
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)
APPLICATION_IMAGE_NAME="app:latest"

REPOSITORY_BASE=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-0}) && pwd)
cd ${SOURCE_DIR}

case "$1" in
"build") docker image build --platform linux/amd64 -t ${APPLICATION_IMAGE_NAME} . ;;
"exec") docker container exec -it $2 sh ;;
"login") aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_BASE} ;;
"push") docker image push ${REPOSITORY_BASE}/app:latest ;;
"rmi") docker image ls -aq | xargs docker image rm -f ;;
"tag") docker image tag ${APPLICATION_IMAGE_NAME} ${REPOSITORY_BASE}/app:latest ;;
*) echo "pass me args" ;;
esac
