#!/usr/bin/env bash

set -e

LOGDATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_DIRECTORY="logs"
PACKER_LOG_FILENAME="packer-build-${LOGDATE}.log"
PACKER_TEMPLATE_PATH="templates/load_cloud.json"

mkdir -p $LOG_DIRECTORY

echo "Validate configuration"
packer validate $PACKER_TEMPLATE_PATH

echo "Build"
export PACKER_LOG=1
export PACKER_LOG_PATH="$LOG_DIRECTORY/$PACKER_LOG_FILENAME"
packer build -force \
  -var "aws_access_key=$AWS_ACCESS_KEY" \
  -var "aws_secret_key=$AWS_SECRET_KEY" \
  $PACKER_TEMPLATE_PATH
