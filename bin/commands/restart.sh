#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down
    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" up -d "${ENTRY_SERVICE}"
}

function command_help() {
  echo_command "kit restart" "Stop and start the application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit restart"
    echo_divider
}