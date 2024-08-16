#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$1" ]; then
        TAG="latest"
    else
        TAG="$1"
    fi
    echo "TAG: ${TAG}"

    if [ "${REGISTRY_TYPE}" == "aws" ] || [ "${REGISTRY_TYPE}" == "AWS" ]; then
        echo "Found AWS ECR Registry"
        aws ecr get-login-password --region "${REGISTRY_REGION}" | docker login --username "${REGISTRY_USERNAME}" --password-stdin "${REGISTRY_URL}"
        docker tag "${REGISTRY_URL}/${REGISTRY_REPO}:${REGISTRY_DEPLOYED_VERSION}" "${REGISTRY_URL}/${REGISTRY_REPO}:${TAG}"
        docker push "${REGISTRY_URL}/${REGISTRY_REPO}:${TAG}"
    else
        echo "No container registry found."
    fi
}

function command_help() {
  echo_command "kit push" "Tag with 'latest' and push docker image to registry defined in .env"
  echo_command "kit push <TAG>" "Tag with custom tag and push docker image to registry defined in .env"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit push"
    echo_example "kit push v1.0.0"
    echo_divider
}