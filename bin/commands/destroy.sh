#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down --rmi all -v --remove-orphans
}

function command_help() {
  echo_command "kit destroy" "Stop the application and delete all images"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit destroy"
    echo_divider
}