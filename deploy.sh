#!/bin/bash -ex

CFN_TEMPLATE=nomad_cluster.yml
STACK_NAME=nomad-cluster
AWS_PROFILE=default
AWS_REGION=us-east-1
IMAGE_ID=ami-97785bed  # latest amzn linux
INSTANCE_TYPE=t2.large
KEY_NAME=nomad
VPC_CIDR=10.10.10.0/24
SUBNET_CIDR=10.10.10.0/24
NOMAD_VERSION=0.8.4
CONSUL_VERSION=1.2.0

if [ -z ${TRUSTED_CIDR} ]; then
  echo "export TRUSTED_CIDR"
  exit 1
fi

PARAMETERS="\
  ImageId=${IMAGE_ID} \
  InstanceType=${INSTANCE_TYPE} \
  KeyName=${KEY_NAME} \
  VpcCidr=${VPC_CIDR} \
  SubnetCidr=${SUBNET_CIDR} \
  TrustedCidr=${TRUSTED_CIDR} \
  NomadVersion=${NOMAD_VERSION} \
  ConsulVersion=${CONSUL_VERSION} \
"

echo -e "\n\nDeploying ${STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --stack-name ${STACK_NAME} \
  --capabilities CAPABILITY_IAM \
  --template-file ${CFN_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --parameter-overrides ${PARAMETERS}

