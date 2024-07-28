#!/usr/bin/env bash

DOCKER_IMAGE="redhat-lambda"

aws ecr create-repository \
    --repository-name ${DOCKER_IMAGE}
