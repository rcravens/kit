#!/usr/bin/env bash

function command_run {
    if [ -z "$2" ] && [ "$1" == "help" ]; then
       command_help
       command_help_details
       return 1
    fi

    docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" run --rm artisan migrate "$@"
}

function command_help() {
  echo_command "kit migrate" "Runs database migrations"
}

function command_help_details() {
    echo_divider
    echo "Examples:"
    echo_example "kit migrate"
    echo_divider
}