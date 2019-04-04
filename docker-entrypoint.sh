#!/bin/bash

set -e

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_REGION

aws eks describe-cluster --name $EKS_CLUSTER_NAME --query cluster.status
aws eks update-kubeconfig --name $EKS_CLUSTER_NAME

#exec "$@"

# Run helm command
if [[ ! -z ${PLUGIN_HELM} ]]; then
  helm ${PLUGIN_HELM}
fi
