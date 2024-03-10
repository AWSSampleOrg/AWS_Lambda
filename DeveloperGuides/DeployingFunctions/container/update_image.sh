#!/usr/bin/env bash

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=$(aws configure get region)

REPOSITORY_NAME="al2023-os-only-lambda"
DOCKER_IMAGE="${REPOSITORY_NAME}:latest"
REPOSITORY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}"

# just add progress and no-cache options to stdout
# docker image build --progress plain --no-cache -t ${DOCKER_IMAGE} .
docker image build -t ${DOCKER_IMAGE} .

aws ecr get-login-password --region ${AWS_REGION} |
    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
docker image tag ${DOCKER_IMAGE} ${REPOSITORY}
docker image push ${REPOSITORY}
