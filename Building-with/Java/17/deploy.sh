#!/usr/bin/env bash

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

ARTIFACT_BUCKET=""

case "$1" in
mvn)
  mvn package
  if [ $? -eq 0 ]; then
    aws s3 cp target/test-program-1.0-SNAPSHOT.jar s3://$ARTIFACT_BUCKET
  fi
  ;;
gradle)
  gradle build -i
  if [ $? -eq 0 ]; then
    aws s3 cp build/distributions/17.zip s3://$ARTIFACT_BUCKET
  fi
  ;;
esac
