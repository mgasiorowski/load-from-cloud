#!/usr/bin/env bash

set -e

RUNDATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_DIRECTORY="logs/terraform"
TERRAFORM_LOG_FILENAME="terraform-${RUNDATE}.log"

echo "Validate configuration"
terraform validate -check-variables=false .

function finish {
    echo "Destroy environment"
    terraform destroy -auto-approve \
        -var "aws_access_key=${AWS_ACCESS_KEY}" \
        -var "aws_secret_key=${AWS_SECRET_KEY}" \
        -var "private_key_path=${PRIVATE_KEY_PATH}" \
        -var "run_date=${RUNDATE}" \
        -var "tag_suffix"="github"
}

trap finish EXIT

mkdir -p ${LOG_DIRECTORY}

echo "Tests"
export TF_LOG=TRACE
export TF_LOG_PATH="${LOG_DIRECTORY}/${TERRAFORM_LOG_FILENAME}"
terraform apply -auto-approve \
    -var "aws_access_key=${AWS_ACCESS_KEY}" \
    -var "aws_secret_key=${AWS_SECRET_KEY}" \
    -var "private_key_path=${PRIVATE_KEY_PATH}" \
    -var "run_date=${RUNDATE}" \
    -var "tag_suffix"="github"
