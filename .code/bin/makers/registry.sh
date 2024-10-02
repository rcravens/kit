#!/usr/bin/env bash

function make_run {
  if [ "$ARGS" == "help" ]; then
     make_help
     return 1
  fi

  PROD_ENV_FILE="${APP_DIRECTORY}/envs/prod/.env"
  if [ ! -f "$PROD_ENV_FILE" ]; then
    echo_red "Error: Missing production environment file."
    return 1
  fi


  # REGISTRY_TYPE
  PS3='Choose the registry type: '
  registry_types=("Amazon ECR" "Docker Hub")
  select type in "${registry_types[@]}"; do
    case $type in
      "Amazon ECR")
        REGISTRY_TYPE=aws
        break
        ;;
      "Docker Hub")
        REGISTRY_TYPE=docker
        break
        ;;
      *)
        echo_red "Invalid registry type. Please choose from: ${registry_types[*]}"
        continue
        ;;
    esac
  done

  # ACCOUNT_ID
  read -p "${GREEN}Enter the registry account id or username: ${RESET}" ACCOUNT_ID
  export ACCOUNT_ID

  # REGISTRY_PROFILE
  read -p "${GREEN}Enter the AWS profile: ${RESET}" REGISTRY_PROFILE
  export REGISTRY_PROFILE

  # REGISTRY_REPO
  read -p "${GREEN}Enter the repository name: ${RESET}" REGISTRY_REPO
  export REGISTRY_REPO

  # REGISTRY_DEPLOYED_VERSION
  read -p "${GREEN}Enter the version to deploy [default: latest]: ${RESET}" REGISTRY_DEPLOYED_VERSION
  REGISTRY_DEPLOYED_VERSION=${REGISTRY_DEPLOYED_VERSION:-"latest"}
  export REGISTRY_DEPLOYED_VERSION

  # REGISTRY_REGION
  REGISTRY_REGION=""
  if [ "$REGISTRY_TYPE" == "aws" ]; then
    # REGISTRY_REGION
    read -p "${GREEN}Enter the Amazon regions [default: us-east-1]: ${RESET}" REGISTRY_REGION
    REGISTRY_REGION=${REGISTRY_REGION:-"us-east-1"}
  fi
  export REGISTRY_REGION

  # REGISTRY_USERNAME
  REGISTRY_USERNAME=""
  if [ "$REGISTRY_TYPE" == "aws" ]; then
    REGISTRY_USERNAME="AWS"
  fi
  export REGISTRY_USERNAME

  # REGISTRY_URL
  case "$REGISTRY_TYPE" in
    "aws")
      REGISTRY_URL="${ACCOUNT_ID}.dkr.ecr.${REGISTRY_REGION}.amazonaws.com"
      ;;
    "docker")
      REGISTRY_URL="${ACCOUNT_ID}"
      ;;
    *)
      REGISTRY_URL=""
  esac
  export REGISTRY_URL


  echo "ACCOUNT_ID: ${ACCOUNT_ID}"
  echo "REGISTRY_TYPE: ${REGISTRY_TYPE}"
  echo "REGISTRY_URL: ${REGISTRY_URL}"
  echo "REGISTRY_REPO: ${REGISTRY_REPO}"
  echo "REGISTRY_DEPLOYED_VERSION: ${REGISTRY_DEPLOYED_VERSION}"
  echo "REGISTRY_REGION: ${REGISTRY_REGION}"
  echo "REGISTRY_USERNAME: ${REGISTRY_USERNAME}"

  sed -i.bak "s|REGISTRY_TYPE=.*|REGISTRY_TYPE=${REGISTRY_TYPE}|" "${PROD_ENV_FILE}"
  sed -i.bak "s|REGISTRY_URL=.*|REGISTRY_URL=${REGISTRY_URL}|" "${PROD_ENV_FILE}"
  sed -i.bak "s|REGISTRY_REPO=.*|REGISTRY_REPO=${REGISTRY_REPO}|" "${PROD_ENV_FILE}"
  sed -i.bak "s|REGISTRY_PROFILE=.*|REGISTRY_PROFILE=${REGISTRY_PROFILE}|" "${PROD_ENV_FILE}"
  sed -i.bak "s|REGISTRY_DEPLOYED_VERSION=.*|REGISTRY_DEPLOYED_VERSION=${REGISTRY_DEPLOYED_VERSION}|" "${PROD_ENV_FILE}"
  sed -i.bak "s|REGISTRY_REGION=.*|REGISTRY_REGION=${REGISTRY_REGION}|" "${PROD_ENV_FILE}"
  sed -i.bak "s|REGISTRY_USERNAME=.*|REGISTRY_USERNAME=${REGISTRY_USERNAME}|" "${PROD_ENV_FILE}"
  sed -i.bak "s|REGISTRY_USERNAME=.*|REGISTRY_USERNAME=${REGISTRY_USERNAME}|" "${PROD_ENV_FILE}"
  rm "${PROD_ENV_FILE}.bak"

  IS_ECR_LOGIN_NEEDED="false"
  DS_AWS_REGION=""
  DS_AWS_ACCOUNT_ID=""
  # Check if deploying from Amazon ECR
  if [ "$REGISTRY_TYPE" == "aws" ]; then
    echo "INSIDE"
    IS_ECR_LOGIN_NEEDED="true"
    DS_AWS_REGION=${REGISTRY_REGION}
    DS_AWS_ACCOUNT_ID=${ACCOUNT_ID}
  fi
  echo "DS_AWS_REGION: ${DS_AWS_REGION}"
  DEPLOY_SETTINGS_FILE="${APP_DIRECTORY}/deploy_settings.yml"
  sed -i.bak "s|is_ecr_login_needed: .*|is_ecr_login_needed: ${IS_ECR_LOGIN_NEEDED}|" "${DEPLOY_SETTINGS_FILE}"
  sed -i.bak "s|ecr_aws_region:.*|ecr_aws_region: ${DS_AWS_REGION}|" "${DEPLOY_SETTINGS_FILE}"
  sed -i.bak "s|ecr_aws_account_id:.*|ecr_aws_account_id: '${DS_AWS_ACCOUNT_ID}'|" "${DEPLOY_SETTINGS_FILE}"
  rm "${DEPLOY_SETTINGS_FILE}.bak"


  echo_green "Container registry settings updated. Changes were made to the following files:"
  echo_yellow "${PROD_ENV_FILE}"
  echo_yellow "${DEPLOY_SETTINGS_FILE}"
  echo_blue "Please inspect those files to double check changes."
}

function make_help() {
  echo_command "kit <APP> make registry" "Configure the deployment container registry."
}