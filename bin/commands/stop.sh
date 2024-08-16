#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down
}

function command_help() {
  echo_command "kit stop" "Stop the application"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit stop"
    echo_divider
}