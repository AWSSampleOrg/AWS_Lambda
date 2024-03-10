#!/usr/bin/env bash

DOCKER_IMAGE="al2023-os-only-lambda"

aws ecr create-repository \
    --repository-name ${DOCKER_IMAGE}
