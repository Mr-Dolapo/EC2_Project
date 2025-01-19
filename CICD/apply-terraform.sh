#!/bin/bash

# fail on any error
set -eu

# go back to the previous directory
cd ..

#creating a temporary .tfvar file
echo "Fetching parameters from Parameter Store"
aws ssm get-parameters-by-path --path "/terraform/dev" --with-decryption --query "Parameters[].{Name:Name,Value:Value}" --output json > parameters.json
echo "Building dev.tfvars file"
jq -r '.[] | "\(.Name | split("/")[-1]) = \"\(.Value)\""' parameters.json > dev.tfvars

# initialize terraform
terraform init -backend-config="env/backend_s3_dev.hcl"

# apply terraform
terraform apply -var-file="dev.tfvars" -auto-approve

# destroy terraform
# terraform destroy -auto-approve