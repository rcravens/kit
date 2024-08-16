#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    if [ -z "$1" ]; then
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" build "${ENTRY_SERVICE}"
    else
        docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" build "$@"
    fi
}

function command_help() {
  echo_command "kit build" "Build the application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit build" "Builds the ${RED}development${RESET} Docker images"
    echo_example "kit build php" "Builds the ${RED}development${RESET} Docker image for the ${BLUE}php${RESET} service"
    echo_example "kit prod build" "Builds the ${RED}production${RESET} Docker images"
    echo_divider
}