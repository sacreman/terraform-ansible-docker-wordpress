#!/bin/bash -e

source ./set-env.sh

APP="$1"
ENV="$2"
COUNT="$3"
SIZE="$4"

terraform apply -var "access_key=${AWS_ACCESS_KEY}" -var "secret_key=${AWS_SECRET}" -var 'region=us-east-1' -var "aws_key_pair_path=${AWS_KEY_PATH}" -var "aws_key_pair_name=${AWS_KEY_PAIR_NAME}" -var "db_username=${DB_USERNAME}" -var "db_password=${DB_PASSWORD}" -var "app_name=${APP}" -var "environment=${ENV}" -var "instance_type=${SIZE}"
export terraform_inventory=$(which terraform-inventory)
export PUBLIC_ACCESS_POINT=$(terraform output | grep app_entrypoint_address | cut -d = -f2)
export DB_URL=$(cat terraform.tfstate | grep endpoint | cut -d : -f2- | tr -d '"' | tr -d , | tr -d ' ')
export ansible_params="DB_HOST=${DB_URL} DB_USER=${DB_USERNAME} -var DB_PASS=${DB_PASSWORD}"
TF_STATE=terraform.tfstate ansible-playbook --inventory-file=${terraform_inventory} ./playbooks/docker-wordpress.yml --extra-vars "${ansible_params}" --user ubuntu --private-key=./steven-acreman-keypair.pem -v


echo "${PUBLIC_ACCESS_POINT}"