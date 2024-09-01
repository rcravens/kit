#!/usr/bin/env bash

function command_run {
    if [ "$ARGS" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$1" ]; then
        TAG="${REGISTRY_DEPLOYED_VERSION}"
    else
        TAG="$1"
    fi
    echo "TAG: ${TAG}"

    if [ "${REGISTRY_TYPE}" == "aws" ] || [ "${REGISTRY_TYPE}" == "AWS" ]; then
        echo "Found AWS ECR Registry"
        aws ecr get-login-password --region "${REGISTRY_REGION}" | docker login --username "${REGISTRY_USERNAME}" --password-stdin "${REGISTRY_URL}"
        docker tag "${REGISTRY_URL}/${REGISTRY_REPO}:${REGISTRY_DEPLOYED_VERSION}" "${REGISTRY_URL}/${REGISTRY_REPO}:${TAG}"
        docker push "${REGISTRY_URL}/${REGISTRY_REPO}:${TAG}"
    elif [ "${REGISTRY_TYPE}" == "docker" ] || [ "${REGISTRY_TYPE}" == "DOCKER" ]; then
        echo "Found Docker Hub Registry."
        docker tag "${REGISTRY_URL}/${REGISTRY_REPO}:${REGISTRY_DEPLOYED_VERSION}" "${REGISTRY_URL}/${REGISTRY_REPO}:${TAG}"
        docker push "${REGISTRY_URL}/${REGISTRY_REPO}:${TAG}"
    else
        echo "No container registry found."
    fi
}

function command_help() {
  echo_command "kit <app> push <tag>" "Tag the latest build and push docker image to container registry configured for the application."
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit laravel push latest" "Tag the latest build for the ${RED}laravel${RESET} application with the ${RED}latest${RESET} and push to the container registry."
    echo_example "kit laravel make registry" "Configure a container registry for the ${RED}laravel${RESET} application."
    echo_divider
}