#!/usr/bin/env bash
SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

DIR=python
mkdir -p ${DIR}
pip install -r requirements.txt -t ${DIR}
zip -r layer.zip ${DIR}

aws lambda publish-layer-version \
    --layer-name requests \
    --description "My layer" \
    --license-info "MIT" \
    --zip-file fileb://layer.zip \
    --compatible-runtimes python3.10 python3.11 python3.12 python3.13 \
    --compatible-architectures "arm64" "x86_64"
