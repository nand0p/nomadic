#!/bin/bash -ex

STACK_NAME=nomad-cluster
VPC_STACK_NAME=${STACK_NAME}-vpc
MASTER_STACK_NAME=${STACK_NAME}-masters
WORKER_STACK_NAME=${STACK_NAME}-workers
VPC_TEMPLATE=vpc.yml
MASTER_TEMPLATE=masters.yml
WORKER_TEMPLATE=workers.yml
AWS_PROFILE=default
AWS_REGION=us-east-1
IMAGE_ID=ami-97785bed  # latest amzn linux
MASTER_INSTANCE_TYPE=m3.medium
WORKER_INSTANCE_TYPE=m3.large
KEY_NAME=nomad
VPC_CIDR=10.10.10.0/24
SUBNET_CIDR=10.10.10.0/24
NOMAD_VERSION=0.8.4
CONSUL_VERSION=1.2.1

if [ -z ${TRUSTED_CIDR} ]; then
  echo "export TRUSTED_CIDR"
  exit 1
fi

VPC_PARAMETERS="\
  VpcCidr=${VPC_CIDR} \
  SubnetCidr=${SUBNET_CIDR} \
  TrustedCidr=${TRUSTED_CIDR} \
"

MASTER_PARAMETERS="\
  ImageId=${IMAGE_ID} \
  InstanceType=${MASTER_INSTANCE_TYPE} \
  KeyName=${KEY_NAME} \
  NomadVersion=${NOMAD_VERSION} \
  ConsulVersion=${CONSUL_VERSION} \
"

WORKER_PARAMETERS="\
  ImageId=${IMAGE_ID} \
  InstanceType=${WORKER_INSTANCE_TYPE} \
  KeyName=${KEY_NAME} \
  NomadVersion=${NOMAD_VERSION} \
  ConsulVersion=${CONSUL_VERSION} \
"

echo -e "\n\nDeploying ${VPC_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${VPC_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --capabilities CAPABILITY_IAM \
  --template-file ${VPC_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --parameter-overrides ${VPC_PARAMETERS}

echo -e "\n\nDeploying ${MASTER_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${MASTER_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --template-file ${MASTER_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --parameter-overrides ${MASTER_PARAMETERS}

echo -e "\n\nDeploying ${WORKER_STACK_NAME} Stack:\n\n"
aws cloudformation deploy \
  --stack-name ${WORKER_STACK_NAME} \
  --profile ${AWS_PROFILE} \
  --region ${AWS_REGION} \
  --template-file ${WORKER_TEMPLATE} \
  --no-fail-on-empty-changeset \
  --parameter-overrides ${WORKER_PARAMETERS}
